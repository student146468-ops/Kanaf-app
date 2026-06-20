"""
URLs API محسّنة للمنظومة - تتضمن جميع نقاط الوصول الضرورية للتطبيق
"""
from django.urls import path
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from management.views import (
    OrphanViewSet, DonationViewSet, VolunteerViewSet, 
    SponsorViewSet, InventoryViewSet, DashboardStatsView, ReportsView
)

# إنشاء Router لإدارة المسارات تلقائياً
router = DefaultRouter()
router.register(r'orphans', OrphanViewSet, basename='orphan')
router.register(r'donations', DonationViewSet, basename='donation')
router.register(r'volunteers', VolunteerViewSet, basename='volunteer')
router.register(r'sponsors', SponsorViewSet, basename='sponsor')
router.register(r'inventory', InventoryViewSet, basename='inventory')

urlpatterns = [
    # ============ المصادقة (Authentication) ============
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # ============ الإحصائيات والتقارير ============
    path('stats/dashboard/', DashboardStatsView.as_view(), name='dashboard_stats'),
    path('reports/', ReportsView.as_view(), name='reports'),
    
    # ============ ViewSets المسجلة في Router ============
] + router.urls
