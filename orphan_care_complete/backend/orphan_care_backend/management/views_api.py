"""
ViewSets API محسّنة للمنظومة - توفر جميع العمليات المطلوبة للتطبيق
"""
from rest_framework import viewsets, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from django.db.models import Count, Sum
from .models import Orphan, Donation, Volunteer, Sponsor, InventoryItem
from .serializers import (
    OrphanSerializer, DonationSerializer, VolunteerSerializer,
    SponsorSerializer, InventorySerializer
)


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
    search_fields = ['donor_name', 'item_type', 'status']
    ordering_fields = ['id', 'status']
    ordering = ['-id']

    @action(detail=False, methods=['get'])
    def my_donations(self, request):
        """الحصول على التبرعات الخاصة بالمستخدم الحالي"""
        donations = Donation.objects.filter(donor_name=request.user.username)
        serializer = self.get_serializer(donations, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات التبرعات"""
        total = Donation.objects.count()
        total_amount = Donation.objects.aggregate(Sum('amount'))['amount__sum'] or 0
        by_status = Donation.objects.values('status').annotate(count=Count('id'))
        return Response({
            'total': total,
            'total_amount': total_amount,
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
    search_fields = ['name', 'specialty']
    ordering_fields = ['id', 'name', 'points']
    ordering = ['-points']

    @action(detail=False, methods=['post'])
    def apply(self, request):
        """التقديم للتطوع"""
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'])
    def statistics(self, request):
        """إحصائيات المتطوعين"""
        total = Volunteer.objects.count()
        total_points = Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0
        return Response({
            'total': total,
            'total_points': total_points,
            'average_points': total_points / total if total > 0 else 0
        })


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
    search_fields = ['item_name']
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
            'orphans_waiting': Orphan.objects.filter(status='ينتظر كفالة').count(),
            'active_donations': Donation.objects.filter(status='قيد التنفيذ').count(),
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
                'total_amount': Donation.objects.aggregate(Sum('amount'))['amount__sum'] or 0,
                'by_status': list(Donation.objects.values('status').annotate(count=Count('id')))
            },
            'volunteers': {
                'total': Volunteer.objects.count(),
                'total_points': Volunteer.objects.aggregate(Sum('points'))['points__sum'] or 0,
            },
            'inventory': {
                'total_items': InventoryItem.objects.count(),
                'total_quantity': InventoryItem.objects.aggregate(Sum('quantity'))['quantity__sum'] or 0,
            }
        })
