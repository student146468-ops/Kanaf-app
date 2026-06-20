"""
ViewSets المحسّنة للمنظومة - نسخة احترافية
"""
from rest_framework import viewsets, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User
from django.db.models import Count, Sum
from .models_professional import (
    CustomUser, Orphan, Donation, Volunteer, VolunteerOpportunity,
    Sponsor, InventoryItem, CareHome, Notification
)
from .serializers_professional import (
    CustomUserSerializer, UserRegistrationSerializer, UserLoginSerializer,
    OrphanSerializer, DonationSerializer, VolunteerSerializer,
    VolunteerOpportunitySerializer, SponsorSerializer, InventorySerializer,
    CareHomeSerializer, NotificationSerializer
)


class AuthenticationView(APIView):
    """
    عرض المصادقة - تسجيل الدخول والتسجيل (بدون OTP)
    """
    permission_classes = [AllowAny]

    def post(self, request):
        action = request.data.get('action')
        
        if action == 'login':
            return self._login(request)
        elif action == 'register':
            return self._register(request)
        else:
            return Response({'error': 'إجراء غير صحيح'}, status=status.HTTP_400_BAD_REQUEST)

    def _login(self, request):
        """تسجيل الدخول"""
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            user = User.objects.get(email=serializer.validated_data['email'])
            custom_user = CustomUser.objects.get(user=user)
            
            # إنشاء التوكنات
            refresh = RefreshToken.for_user(user)
            
            return Response({
                'access_token': str(refresh.access_token),
                'refresh_token': str(refresh),
                'user': CustomUserSerializer(custom_user).data,
                'message': 'تم تسجيل الدخول بنجاح'
            }, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def _register(self, request):
        """التسجيل الجديد"""
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            custom_user = serializer.save()
            
            # إنشاء التوكنات
            refresh = RefreshToken.for_user(custom_user.user)
            
            return Response({
                'access_token': str(refresh.access_token),
                'refresh_token': str(refresh),
                'user': CustomUserSerializer(custom_user).data,
                'message': 'تم التسجيل بنجاح'
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class OrphanViewSet(viewsets.ModelViewSet):
    """
    ViewSet للأيتام - توفر عمليات CRUD كاملة
    """
    queryset = Orphan.objects.all()
    serializer_class = OrphanSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'status']
    ordering_fields = ['id', 'name', 'age', 'status']
    ordering = ['-id']

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات الأيتام"""
        total = Orphan.objects.count()
        by_status = Orphan.objects.values('status').annotate(count=Count('id'))
        return Response({
            'total': total,
            'by_status': list(by_status)
        })


class DonationViewSet(viewsets.ModelViewSet):
    """
    ViewSet للتبرعات - توفر عمليات CRUD كاملة
    """
    queryset = Donation.objects.all()
    serializer_class = DonationSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['item_type', 'status']
    ordering_fields = ['id', 'status']
    ordering = ['-id']

    def perform_create(self, serializer):
        """تعيين المتبرع الحالي"""
        custom_user = CustomUser.objects.get(user=self.request.user)
        serializer.save(donor=custom_user)

    @action(detail=False, methods=['get'])
    def my_donations(self, request):
        """الحصول على التبرعات الخاصة بالمستخدم الحالي"""
        custom_user = CustomUser.objects.get(user=request.user)
        donations = Donation.objects.filter(donor=custom_user)
        serializer = self.get_serializer(donations, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات التبرعات"""
        total = Donation.objects.count()
        total_amount = Donation.objects.filter(donation_type='financial').aggregate(Sum('amount'))['amount__sum'] or 0
        by_status = Donation.objects.values('status').annotate(count=Count('id'))
        return Response({
            'total': total,
            'total_amount': float(total_amount),
            'by_status': list(by_status)
        })


class VolunteerViewSet(viewsets.ModelViewSet):
    """
    ViewSet للمتطوعين - توفر عمليات CRUD كاملة
    """
    queryset = Volunteer.objects.all()
    serializer_class = VolunteerSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['specialty']
    ordering_fields = ['id', 'points']
    ordering = ['-points']

    @action(detail=False, methods=['post'])
    def apply(self, request):
        """التقديم للتطوع"""
        custom_user = CustomUser.objects.get(user=request.user)
        
        # التحقق من عدم وجود تطوع سابق
        if Volunteer.objects.filter(user=custom_user).exists():
            return Response(
                {'error': 'أنت مسجل بالفعل كمتطوع'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=custom_user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات المتطوعين"""
        total = Volunteer.objects.count()
        total_points = Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0
        total_hours = Volunteer.objects.aggregate(Sum('hours_worked'))['hours_worked__sum'] or 0
        return Response({
            'total': total,
            'total_points': total_points,
            'total_hours': total_hours,
            'average_points': total_points / total if total > 0 else 0
        })


class VolunteerOpportunityViewSet(viewsets.ModelViewSet):
    """
    ViewSet لفرص التطوع
    """
    queryset = VolunteerOpportunity.objects.all()
    serializer_class = VolunteerOpportunitySerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'status']
    ordering_fields = ['id', 'start_date']
    ordering = ['-start_date']


class SponsorViewSet(viewsets.ModelViewSet):
    """
    ViewSet للكفلاء - توفر عمليات CRUD كاملة
    """
    queryset = Sponsor.objects.all()
    serializer_class = SponsorSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'phone']
    ordering_fields = ['id', 'name']
    ordering = ['-id']


class InventoryViewSet(viewsets.ModelViewSet):
    """
    ViewSet للمخزن - توفر عمليات CRUD كاملة
    """
    queryset = InventoryItem.objects.all()
    serializer_class = InventorySerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['item_name', 'category']
    ordering_fields = ['id', 'quantity']
    ordering = ['-id']

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات المخزن"""
        total_items = InventoryItem.objects.count()
        total_quantity = InventoryItem.objects.aggregate(Sum('quantity'))['quantity__sum'] or 0
        return Response({
            'total_items': total_items,
            'total_quantity': total_quantity
        })


class CareHomeViewSet(viewsets.ModelViewSet):
    """
    ViewSet لدور الرعاية
    """
    queryset = CareHome.objects.all()
    serializer_class = CareHomeSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'address']
    ordering_fields = ['id', 'name']
    ordering = ['-id']


class NotificationViewSet(viewsets.ModelViewSet):
    """
    ViewSet للإشعارات
    """
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ['created_at']
    ordering = ['-created_at']

    def get_queryset(self):
        """الحصول على إشعارات المستخدم الحالي فقط"""
        custom_user = CustomUser.objects.get(user=self.request.user)
        return Notification.objects.filter(user=custom_user)

    @action(detail=False, methods=['get'])
    def unread_count(self, request):
        """عدد الإشعارات غير المقروءة"""
        custom_user = CustomUser.objects.get(user=request.user)
        count = Notification.objects.filter(user=custom_user, is_read=False).count()
        return Response({'unread_count': count})

    @action(detail=True, methods=['post'])
    def mark_as_read(self, request, pk=None):
        """تحديد الإشعار كمقروء"""
        notification = self.get_object()
        notification.is_read = True
        notification.save()
        return Response({'status': 'تم تحديد الإشعار كمقروء'})


class DashboardStatsView(APIView):
    """
    عرض إحصائيات لوحة التحكم الرئيسية
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({
            'total_orphans': Orphan.objects.count(),
            'total_donations': Donation.objects.count(),
            'total_volunteers': Volunteer.objects.count(),
            'total_sponsors': Sponsor.objects.count(),
            'total_inventory_items': InventoryItem.objects.count(),
            'total_care_homes': CareHome.objects.count(),
            'orphans_waiting': Orphan.objects.filter(status='waiting').count(),
            'active_donations': Donation.objects.filter(status='in_progress').count(),
            'active_volunteers': Volunteer.objects.filter(is_active=True).count(),
        })


class ReportsView(APIView):
    """
    عرض التقارير الشاملة
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response({
            'orphans': {
                'total': Orphan.objects.count(),
                'by_status': list(Orphan.objects.values('status').annotate(count=Count('id')))
            },
            'donations': {
                'total': Donation.objects.count(),
                'total_amount': float(Donation.objects.filter(donation_type='financial').aggregate(Sum('amount'))['amount__sum'] or 0),
                'by_status': list(Donation.objects.values('status').annotate(count=Count('id')))
            },
            'volunteers': {
                'total': Volunteer.objects.count(),
                'total_points': Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0,
                'total_hours': Volunteer.objects.aggregate(Sum('hours_worked'))['hours_worked__sum'] or 0,
            },
            'inventory': {
                'total_items': InventoryItem.objects.count(),
                'total_quantity': InventoryItem.objects.aggregate(Sum('quantity'))['quantity__sum'] or 0,
            }
        })
