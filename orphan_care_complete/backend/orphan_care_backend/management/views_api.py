"""Active REST API views for the Kanaf backend."""
import logging
import re

from django.contrib.auth import authenticate, get_user_model
from django.db import IntegrityError, connection
from django.db.models import Count, F, Sum
from django.db.models.deletion import ProtectedError
from django.db import transaction
from django.utils.translation import gettext_lazy as _
from drf_spectacular.utils import extend_schema, inline_serializer
from rest_framework import filters, serializers, status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, BasePermission, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from .models import Donation, InventoryItem, Need, Orphan, Sponsor, Volunteer
from .serializers import (
    CareHomeSerializer,
    DonationSerializer,
    InventorySerializer,
    NeedSerializer,
    NotificationSerializer,
    OrphanSerializer,
    SponsorSerializer,
    UserProfileSerializer,
    VolunteerApplicationSerializer,
    VolunteerSerializer,
    VolunteerOpportunitySerializer,
)
from .models import CareHome, Notification, UserProfile, VolunteerApplication, VolunteerOpportunity

User = get_user_model()
logger = logging.getLogger(__name__)
VERIFICATION_TITLE_PREFIX = 'Codex verification'
VERIFICATION_DESCRIPTION_PREFIX = 'Local verification'
PHONE_NUMBER_PATTERN = re.compile(r'^(091|092|093|094)[0-9]{7}$')
PHONE_EXISTS_MESSAGE = 'رقم الهاتف مستخدم بالفعل.'
EMAIL_EXISTS_MESSAGE = 'هذا البريد الإلكتروني مستخدم بالفعل.'
USERNAME_EXISTS_MESSAGE = 'اسم المستخدم مستخدم بالفعل.'
PHONE_VALIDATION_MESSAGE = 'رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ بـ 091 أو 092 أو 093 أو 094.'
PASSWORD_VALIDATION_MESSAGE = 'كلمة المرور ضعيفة. يجب أن تتكون من 8 خانات على الأقل وتحتوي على حروف وأرقام.'


def _is_valid_phone_number(phone_number):
    if not isinstance(phone_number, str):
        return False
    return bool(PHONE_NUMBER_PATTERN.fullmatch(phone_number))


def _is_valid_registration_password(password):
    if not isinstance(password, str):
        return False
    return (
        len(password) >= 8
        and re.search(r'[A-Za-z]', password)
        and re.search(r'[0-9]', password)
    )


def _without_verification_data(queryset):
    return queryset.exclude(
        title__istartswith=VERIFICATION_TITLE_PREFIX,
    ).exclude(
        description__istartswith=VERIFICATION_DESCRIPTION_PREFIX,
    )


class StaffDeletePermission(BasePermission):
    message = 'Only staff users can delete this record.'

    def has_permission(self, request, view):
        if request.method == 'DELETE':
            return bool(request.user and request.user.is_authenticated and request.user.is_staff)
        return bool(request.user and request.user.is_authenticated)


class StaffWriteAuthenticatedReadPermission(BasePermission):
    message = 'Only staff users can update this record.'

    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.method in ('GET', 'HEAD', 'OPTIONS', 'POST'):
            return True
        return request.user.is_staff


class SafeDestroyMixin:
    protected_delete_detail = 'Cannot delete this record because it is linked to other saved records.'
    protect_related_on_delete = False
    protected_related_names = ()

    def _related_counts(self, instance):
        related_counts = {}
        for relation in instance._meta.related_objects:
            accessor = relation.get_accessor_name()
            if self.protected_related_names and accessor not in self.protected_related_names:
                continue
            manager = getattr(instance, accessor, None)
            if manager is None:
                continue
            try:
                count = manager.count()
            except Exception:
                continue
            if count:
                related_counts[accessor] = count
        return related_counts

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        related_counts = self._related_counts(instance) if self.protect_related_on_delete else {}
        if related_counts:
            logger.info(
                'Delete blocked for %s id=%s because of related records: %s',
                instance.__class__.__name__,
                instance.pk,
                related_counts,
            )
            return Response(
                {'detail': self.protected_delete_detail, 'related': related_counts},
                status=status.HTTP_409_CONFLICT,
            )

        try:
            self.perform_destroy(instance)
        except ProtectedError as exc:
            logger.warning(
                'Protected delete blocked for %s id=%s: %s',
                instance.__class__.__name__,
                instance.pk,
                exc,
                exc_info=True,
            )
            return Response({'detail': self.protected_delete_detail}, status=status.HTTP_409_CONFLICT)
        except IntegrityError as exc:
            logger.warning(
                'Database delete blocked for %s id=%s: %s',
                instance.__class__.__name__,
                instance.pk,
                exc,
                exc_info=True,
            )
            return Response(
                {'detail': 'Delete was not completed because of related database records.'},
                status=status.HTTP_409_CONFLICT,
            )
        except Exception as exc:
            logger.exception(
                'Unexpected delete failure for %s id=%s: %s',
                instance.__class__.__name__,
                instance.pk,
                exc,
            )
            return Response({'detail': 'Delete was not completed.'}, status=status.HTTP_400_BAD_REQUEST)

        return Response(status=status.HTTP_204_NO_CONTENT)


def _create_notification(user, notification_type, title, message):
    if not user:
        return
    Notification.objects.create(
        user=user,
        notification_type=notification_type,
        title=title,
        message=message,
    )
ORPHAN_WAITING_STATUSES = ['ينتظر كفالة', 'ظٹظ†طھط¸ط± ظƒظپط§ظ„ط©']
DONATION_ACTIVE_STATUSES = ['قيد التنفيذ', 'ظ‚ظٹط¯ ط§ظ„طھظ†ظپظٹط°']


def _profile_role(user):
    profile = getattr(user, 'profile', None)
    return getattr(profile, 'role', '')


def _is_accepted_status(value):
    return value in (VolunteerApplication.STATUS_ACCEPTED, 'approved')


AUTH_RESPONSE_SCHEMA = inline_serializer(
    name='AuthResponse',
    fields={
        'access': serializers.CharField(),
        'refresh': serializers.CharField(),
        'access_token': serializers.CharField(),
        'refresh_token': serializers.CharField(),
        'token': serializers.CharField(),
        'user': serializers.DictField(),
    },
)


def _user_payload(user):
    profile, _ = UserProfile.objects.get_or_create(user=user)
    return {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'first_name': user.first_name,
        'last_name': user.last_name,
        'is_staff': user.is_staff,
        'is_superuser': user.is_superuser,
        'role': profile.role,
        'phone_number': profile.phone_number,
        'is_verified': profile.is_verified,
    }


def _token_payload(user):
    refresh = RefreshToken.for_user(user)
    access_token = str(refresh.access_token)
    refresh_token = str(refresh)
    return {
        'access': access_token,
        'refresh': refresh_token,
        'access_token': access_token,
        'refresh_token': refresh_token,
        'token': access_token,
        'user': _user_payload(user),
    }


class RegisterView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(
        request=inline_serializer(
            name='RegisterRequest',
            fields={
                'username': serializers.CharField(required=False),
                'email': serializers.EmailField(),
                'password': serializers.CharField(write_only=True),
                'password_confirm': serializers.CharField(write_only=True),
                'first_name': serializers.CharField(required=False),
                'last_name': serializers.CharField(required=False),
            },
        ),
        responses={201: AUTH_RESPONSE_SCHEMA},
    )
    def post(self, request):
        username = request.data.get('username', '').strip()
        email = request.data.get('email', '').strip().lower()
        password = request.data.get('password', '')
        password_confirm = request.data.get('password_confirm', '')
        first_name = request.data.get('first_name', '').strip()
        last_name = request.data.get('last_name', '').strip()
        phone_number = request.data.get('phone_number', '')

        if not email:
            return Response({'detail': _('email is required')}, status=status.HTTP_400_BAD_REQUEST)
        if not username:
            username = email
        if not all([username, password, password_confirm]):
            return Response({'detail': _('username, password and password_confirm are required')}, status=status.HTTP_400_BAD_REQUEST)
        if password != password_confirm:
            return Response({'detail': _('passwords do not match')}, status=status.HTTP_400_BAD_REQUEST)
        if User.objects.filter(email__iexact=email).exists():
            return Response(
                {'email': [EMAIL_EXISTS_MESSAGE], 'detail': EMAIL_EXISTS_MESSAGE},
                status=status.HTTP_400_BAD_REQUEST,
            )
        if User.objects.filter(username__iexact=username).exists():
            return Response(
                {'username': [USERNAME_EXISTS_MESSAGE], 'detail': USERNAME_EXISTS_MESSAGE},
                status=status.HTTP_400_BAD_REQUEST,
            )
        role = request.data.get('role') or UserProfile.ROLE_DONOR
        valid_roles = {UserProfile.ROLE_DONOR, UserProfile.ROLE_VOLUNTEER}
        if role not in valid_roles:
            return Response({'detail': _('invalid role')}, status=status.HTTP_400_BAD_REQUEST)
        if not _is_valid_phone_number(phone_number):
            return Response({'detail': PHONE_VALIDATION_MESSAGE}, status=status.HTTP_400_BAD_REQUEST)
        if UserProfile.objects.filter(phone_number=phone_number).exists():
            return Response(
                {'phone_number': [PHONE_EXISTS_MESSAGE], 'detail': PHONE_EXISTS_MESSAGE},
                status=status.HTTP_400_BAD_REQUEST,
            )
        if not _is_valid_registration_password(password):
            return Response({'detail': PASSWORD_VALIDATION_MESSAGE}, status=status.HTTP_400_BAD_REQUEST)

        try:
            with transaction.atomic():
                user = User.objects.create_user(
                    username=username,
                    email=email,
                    password=password,
                    first_name=first_name,
                    last_name=last_name,
                )
                UserProfile.objects.create(
                    user=user,
                    role=role,
                    phone_number=phone_number,
                )
        except IntegrityError:
            if User.objects.filter(email__iexact=email).exists():
                return Response(
                    {'email': [EMAIL_EXISTS_MESSAGE], 'detail': EMAIL_EXISTS_MESSAGE},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if User.objects.filter(username__iexact=username).exists():
                return Response(
                    {'username': [USERNAME_EXISTS_MESSAGE], 'detail': USERNAME_EXISTS_MESSAGE},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if UserProfile.objects.filter(phone_number=phone_number).exists():
                return Response(
                    {'phone_number': [PHONE_EXISTS_MESSAGE], 'detail': PHONE_EXISTS_MESSAGE},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            return Response(
                {'detail': _('could not create account')},
                status=status.HTTP_400_BAD_REQUEST,
            )

        payload = _token_payload(user)
        payload.update({'id': user.id, 'username': user.username, 'email': user.email})
        return Response(payload, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(
        request=inline_serializer(
            name='LoginRequest',
            fields={
                'username': serializers.CharField(required=False),
                'email': serializers.EmailField(required=False),
                'password': serializers.CharField(write_only=True),
            },
        ),
        responses={200: AUTH_RESPONSE_SCHEMA},
    )
    def post(self, request):
        username_or_email = (request.data.get('username') or request.data.get('email') or '').strip()
        password = request.data.get('password', '')

        if not username_or_email or not password:
            return Response({'detail': _('username/email and password are required')}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.filter(username__iexact=username_or_email).first()
        if user is None:
            user = User.objects.filter(email__iexact=username_or_email).first()
        if user is None:
            return Response({'detail': _('invalid credentials')}, status=status.HTTP_401_UNAUTHORIZED)

        authenticated_user = authenticate(request, username=user.username, password=password)
        if authenticated_user is None:
            return Response({'detail': _('invalid credentials')}, status=status.HTTP_401_UNAUTHORIZED)

        return Response(_token_payload(authenticated_user), status=status.HTTP_200_OK)


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        request=None,
        responses=inline_serializer(name='LogoutResponse', fields={'detail': serializers.CharField()}),
    )
    def post(self, request):
        return Response({'detail': _('logged out')}, status=status.HTTP_200_OK)


class HealthView(APIView):
    permission_classes = [AllowAny]

    @extend_schema(responses=inline_serializer(name='HealthResponse', fields={'status': serializers.CharField(), 'database': serializers.CharField()}))
    def get(self, request):
        try:
            connection.ensure_connection()
        except Exception:
            return Response({'status': 'error', 'database': 'unavailable'}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
        return Response({'status': 'ok', 'database': 'ok'})


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(responses=inline_serializer(name='MeResponse', fields={'id': serializers.IntegerField()}))
    def get(self, request):
        return Response(_user_payload(request.user))


class OrphanViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = Orphan.objects.all()
    serializer_class = OrphanSerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'status']
    ordering_fields = ['id', 'name', 'age', 'status']
    ordering = ['-id']

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        total = Orphan.objects.count()
        by_status = Orphan.objects.values('status').annotate(count=Count('id'))
        return Response({'total': total, 'by_status': list(by_status)})


class DonationViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = Donation.objects.all()
    serializer_class = DonationSerializer
    permission_classes = [StaffWriteAuthenticatedReadPermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['donor_name', 'item_type', 'status', 'description', 'need__title']
    ordering_fields = ['id', 'status', 'donation_date']
    ordering = ['-donation_date', '-id']

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return Donation.objects.none()
        queryset = Donation.objects.select_related('user', 'need')
        if self.request.user.is_staff:
            return queryset
        return queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        if _profile_role(self.request.user) != UserProfile.ROLE_DONOR:
            raise serializers.ValidationError({'detail': 'Only donor users can create donations.'})
        donor_name = (
            self.request.user.get_full_name()
            or self.request.user.username
            or self.request.user.email
        )
        serializer.save(
            user=self.request.user,
            donor_name=donor_name,
            status=Donation.STATUS_PENDING,
        )

    def perform_update(self, serializer):
        previous_status = serializer.instance.status
        donation = serializer.save()
        if donation.user_id and previous_status != donation.status:
            _create_notification(
                donation.user,
                Notification.TYPE_DONATION,
                'Donation status updated',
                f'Your donation request is now {donation.status}.',
            )

    @action(detail=False, methods=['get'], url_path='my-donations')
    def my_donations(self, request):
        donations = self.get_queryset()
        serializer = self.get_serializer(donations, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        queryset = self.get_queryset()
        total = queryset.count()
        by_status = queryset.values('status').annotate(count=Count('id'))
        total_amount = queryset.aggregate(Sum('amount'))['amount__sum'] or 0
        return Response({'total': total, 'total_amount': total_amount, 'by_status': list(by_status)})


class VolunteerViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = Volunteer.objects.all()
    serializer_class = VolunteerSerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'specialty']
    ordering_fields = ['id', 'name', 'points']
    ordering = ['-points']

    @action(detail=False, methods=['post'])
    def apply(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        total = Volunteer.objects.count()
        total_points = Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0
        return Response({
            'total': total,
            'total_points': total_points,
            'average_points': total_points / total if total > 0 else 0,
        })


class SponsorViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = Sponsor.objects.all()
    serializer_class = SponsorSerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'phone']
    ordering_fields = ['id', 'name']
    ordering = ['-id']


class InventoryViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = InventoryItem.objects.all()
    serializer_class = InventorySerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['item_name']
    ordering_fields = ['id', 'quantity']
    ordering = ['-id']

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        total_items = InventoryItem.objects.count()
        total_quantity = InventoryItem.objects.aggregate(Sum('quantity'))['quantity__sum'] or 0
        return Response({'total_items': total_items, 'total_quantity': total_quantity})


class NeedViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = _without_verification_data(
        Need.objects.exclude(status=Need.STATUS_ARCHIVED)
    )
    serializer_class = NeedSerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'description', 'category', 'priority', 'status']
    ordering_fields = ['id', 'title', 'priority', 'deadline', 'created_at']
    ordering = ['-created_at']

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

    def destroy(self, request, *args, **kwargs):
        need = self.get_object()
        need.status = Need.STATUS_ARCHIVED
        need.save(update_fields=['status', 'updated_at'])
        logger.info('Need id=%s was archived through DELETE by user id=%s', need.pk, request.user.pk)
        return Response(status=status.HTTP_204_NO_CONTENT)

    @action(detail=True, methods=['post'])
    def archive(self, request, pk=None):
        need = self.get_object()
        need.status = Need.STATUS_ARCHIVED
        need.save(update_fields=['status', 'updated_at'])
        return Response(self.get_serializer(need).data)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        total = self.get_queryset().count()
        by_status = Need.objects.values('status').annotate(count=Count('id'))
        return Response({'total': total, 'by_status': list(by_status)})


class VolunteerOpportunityViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = _without_verification_data(VolunteerOpportunity.objects.all())
    serializer_class = VolunteerOpportunitySerializer
    permission_classes = [StaffDeletePermission]
    protect_related_on_delete = True
    protected_related_names = ('applications',)
    protected_delete_detail = 'Cannot delete this volunteer opportunity because it has saved applications.'
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'description', 'location', 'status']
    ordering_fields = ['id', 'title', 'start_date', 'status']
    ordering = ['-start_date', '-created_at']

    @action(detail=True, methods=['post'])
    def apply(self, request, pk=None):
        if _profile_role(request.user) != UserProfile.ROLE_VOLUNTEER:
            return Response({'detail': 'Only volunteer users can apply to opportunities.'}, status=status.HTTP_403_FORBIDDEN)
        opportunity = self.get_object()
        application, created = VolunteerApplication.objects.get_or_create(
            opportunity=opportunity,
            user=request.user,
            defaults={'message': request.data.get('message', '')},
        )
        serializer = VolunteerApplicationSerializer(application)
        return Response(serializer.data, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)


class VolunteerApplicationViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    serializer_class = VolunteerApplicationSerializer
    permission_classes = [StaffWriteAuthenticatedReadPermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['opportunity__title', 'message', 'status']
    ordering_fields = ['id', 'created_at', 'status']
    ordering = ['-created_at']

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return VolunteerApplication.objects.none()
        queryset = VolunteerApplication.objects.select_related('user', 'opportunity')
        if self.request.user.is_staff:
            return queryset
        return queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        previous_status = serializer.instance.status
        application = serializer.save()
        if previous_status != application.status:
            _create_notification(
                application.user,
                Notification.TYPE_VOLUNTEER,
                'Volunteer application status updated',
                f'Your application for {application.opportunity.title} is now {application.status}.',
            )

    def perform_destroy(self, instance):
        with transaction.atomic():
            if _is_accepted_status(instance.status):
                VolunteerOpportunity.objects.filter(
                    pk=instance.opportunity_id,
                    current_volunteers__gt=0,
                ).update(current_volunteers=F('current_volunteers') - 1)
            instance.delete()

    @action(detail=True, methods=['post'])
    def approve(self, request, pk=None):
        application = self.get_object()
        if not request.user.is_staff:
            return Response({'detail': 'Only staff can approve applications.'}, status=status.HTTP_403_FORBIDDEN)
        with transaction.atomic():
            opportunity = VolunteerOpportunity.objects.select_for_update().get(pk=application.opportunity_id)
            if not _is_accepted_status(application.status):
                if opportunity.current_volunteers >= opportunity.required_volunteers:
                    return Response({'detail': 'Opportunity is already full.'}, status=status.HTTP_400_BAD_REQUEST)
                application.status = VolunteerApplication.STATUS_ACCEPTED
                application.save(update_fields=['status', 'updated_at'])
                VolunteerOpportunity.objects.filter(pk=opportunity.pk).update(current_volunteers=F('current_volunteers') + 1)
        application.refresh_from_db()
        _create_notification(
            application.user,
            Notification.TYPE_VOLUNTEER,
            'Volunteer application approved',
            f'Your application for {application.opportunity.title} was approved.',
        )
        return Response(self.get_serializer(application).data)

    @action(detail=False, methods=['get'], url_path='my-applications')
    def my_applications(self, request):
        applications = self.get_queryset()
        serializer = self.get_serializer(applications, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        application = self.get_object()
        if not request.user.is_staff:
            return Response({'detail': 'Only staff can reject applications.'}, status=status.HTTP_403_FORBIDDEN)
        application.status = VolunteerApplication.STATUS_REJECTED
        application.save(update_fields=['status', 'updated_at'])
        _create_notification(
            application.user,
            Notification.TYPE_VOLUNTEER,
            'Volunteer application rejected',
            f'Your application for {application.opportunity.title} was rejected.',
        )
        return Response(self.get_serializer(application).data)

    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        application = self.get_object()
        if not request.user.is_staff:
            return Response({'detail': 'Only staff can complete applications.'}, status=status.HTTP_403_FORBIDDEN)
        application.status = VolunteerApplication.STATUS_COMPLETED
        application.save(update_fields=['status', 'updated_at'])
        _create_notification(
            application.user,
            Notification.TYPE_VOLUNTEER,
            'Volunteer application completed',
            f'Your application for {application.opportunity.title} was completed.',
        )
        return Response(self.get_serializer(application).data)


class CareHomeViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    queryset = CareHome.objects.all()
    serializer_class = CareHomeSerializer
    permission_classes = [StaffDeletePermission]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'address', 'phone', 'email']
    ordering_fields = ['id', 'name', 'orphan_count']
    ordering = ['name']


class NotificationViewSet(SafeDestroyMixin, viewsets.ModelViewSet):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]
    pagination_class = None
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'message', 'notification_type']
    ordering_fields = ['id', 'created_at', 'is_read']
    ordering = ['-created_at']

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return Notification.objects.none()
        if self.request.user.is_staff:
            return Notification.objects.select_related('user').all()
        return Notification.objects.select_related('user').filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=False, methods=['get'])
    def unread_count(self, request):
        return Response({'unread_count': self.get_queryset().filter(is_read=False).count()})

    @action(detail=True, methods=['post'])
    def mark_as_read(self, request, pk=None):
        notification = self.get_object()
        notification.is_read = True
        notification.save(update_fields=['is_read'])
        return Response({'status': 'read'})

    @action(detail=False, methods=['post'])
    def mark_all_as_read(self, request):
        self.get_queryset().filter(is_read=False).update(is_read=True)
        return Response({'status': 'read'})


class ProfileViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = UserProfileSerializer
    permission_classes = [IsAuthenticated]
    pagination_class = None

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return UserProfile.objects.none()
        if self.request.user.is_staff:
            return UserProfile.objects.select_related('user').all()
        return UserProfile.objects.select_related('user').filter(user=self.request.user)


class DashboardStatsView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(responses=inline_serializer(name='DashboardStatsResponse', fields={'total_orphans': serializers.IntegerField()}))
    def get(self, request):
        return Response({
            'total_orphans': Orphan.objects.count(),
            'total_donations': Donation.objects.count(),
            'total_volunteers': Volunteer.objects.count(),
            'total_sponsors': Sponsor.objects.count(),
            'total_inventory_items': InventoryItem.objects.count(),
            'total_care_homes': CareHome.objects.count(),
            'total_needs': Need.objects.exclude(status=Need.STATUS_ARCHIVED).count(),
            'open_needs': Need.objects.filter(status=Need.STATUS_OPEN).count(),
            'total_volunteer_opportunities': VolunteerOpportunity.objects.count(),
            'unread_notifications': Notification.objects.filter(is_read=False).count() if request.user.is_staff else Notification.objects.filter(user=request.user, is_read=False).count(),
            'orphans_waiting': Orphan.objects.filter(status__in=ORPHAN_WAITING_STATUSES).count(),
            'active_donations': Donation.objects.filter(status__in=DONATION_ACTIVE_STATUSES).count(),
        })


class ReportsView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(responses=inline_serializer(name='ReportsResponse', fields={'orphans': serializers.DictField()}))
    def get(self, request):
        return Response({
            'orphans': {
                'total': Orphan.objects.count(),
                'by_status': list(Orphan.objects.values('status').annotate(count=Count('id'))),
            },
            'donations': {
                'total': Donation.objects.count(),
                'total_amount': 0,
                'by_status': list(Donation.objects.values('status').annotate(count=Count('id'))),
            },
            'volunteers': {
                'total': Volunteer.objects.count(),
                'total_points': Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0,
            },
            'inventory': {
                'total_items': InventoryItem.objects.count(),
                'total_quantity': InventoryItem.objects.aggregate(Sum('quantity'))['quantity__sum'] or 0,
            },
            'needs': {
                'total': Need.objects.exclude(status=Need.STATUS_ARCHIVED).count(),
                'open': Need.objects.filter(status=Need.STATUS_OPEN).count(),
                'by_status': list(Need.objects.values('status').annotate(count=Count('id'))),
            },
            'care_homes': {
                'total': CareHome.objects.count(),
                'total_orphans': CareHome.objects.aggregate(Sum('orphan_count'))['orphan_count__sum'] or 0,
            },
            'volunteer_opportunities': {
                'total': VolunteerOpportunity.objects.count(),
                'open': VolunteerOpportunity.objects.filter(status=VolunteerOpportunity.STATUS_OPEN).count(),
                'applications': VolunteerApplication.objects.count(),
            },
        })
