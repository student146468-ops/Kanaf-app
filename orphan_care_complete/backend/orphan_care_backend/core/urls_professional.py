"""
URLs API محسّنة للمنظومة - نسخة احترافية
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from management.views_professional import (
    AuthenticationView,
    OrphanViewSet, DonationViewSet, VolunteerViewSet, VolunteerOpportunityViewSet,
    SponsorViewSet, InventoryViewSet, CareHomeViewSet, NotificationViewSet,
    DashboardStatsView, ReportsView
)

# إنشاء Router لإدارة المسارات تلقائياً
router = DefaultRouter()
router.register(r'orphans', OrphanViewSet, basename='orphan')
router.register(r'donations', DonationViewSet, basename='donation')
router.register(r'volunteers', VolunteerViewSet, basename='volunteer')
router.register(r'volunteer-opportunities', VolunteerOpportunityViewSet, basename='volunteer_opportunity')
router.register(r'sponsors', SponsorViewSet, basename='sponsor')
router.register(r'inventory', InventoryViewSet, basename='inventory')
router.register(r'care-homes', CareHomeViewSet, basename='care_home')
router.register(r'notifications', NotificationViewSet, basename='notification')

urlpatterns = [
    # ============ المصادقة (Authentication) - بدون OTP ============
    path('auth/login/', AuthenticationView.as_view(), name='login'),
    path('auth/register/', AuthenticationView.as_view(), name='register'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # ============ الإحصائيات والتقارير ============
    path('stats/dashboard/', DashboardStatsView.as_view(), name='dashboard_stats'),
    path('reports/', ReportsView.as_view(), name='reports'),
    
    # ============ ViewSets المسجلة في Router ============
    path('', include(router.urls)),
]
