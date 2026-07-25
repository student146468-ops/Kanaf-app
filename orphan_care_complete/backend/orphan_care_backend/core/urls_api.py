"""
URLs API محسّنة للمنظومة - تتضمن جميع نقاط الوصول الضرورية للتطبيق
"""
from django.urls import path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenRefreshView

from management.views_api import (
    DashboardStatsView,
    CareHomeViewSet,
    DonationViewSet,
    HealthView,
    InventoryViewSet,
    LoginView,
    LogoutView,
    MeView,
    NeedViewSet,
    NotificationViewSet,
    OrphanViewSet,
    ProfileViewSet,
    RegisterView,
    ReportsView,
    SponsorViewSet,
    VolunteerApplicationViewSet,
    VolunteerOpportunityViewSet,
    VolunteerViewSet,
)

router = DefaultRouter()
router.register(r'orphans', OrphanViewSet, basename='orphan')
router.register(r'donations', DonationViewSet, basename='donation')
router.register(r'volunteers', VolunteerViewSet, basename='volunteer')
router.register(r'volunteer-opportunities', VolunteerOpportunityViewSet, basename='volunteer_opportunity')
router.register(r'volunteer-applications', VolunteerApplicationViewSet, basename='volunteer_application')
router.register(r'sponsors', SponsorViewSet, basename='sponsor')
router.register(r'inventory', InventoryViewSet, basename='inventory')
router.register(r'needs', NeedViewSet, basename='need')
router.register(r'care-homes', CareHomeViewSet, basename='care_home')
router.register(r'notifications', NotificationViewSet, basename='notification')
router.register(r'profiles', ProfileViewSet, basename='profile')

urlpatterns = [
    path('auth/login/', LoginView.as_view(), name='token_obtain_pair'),
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/logout/', LogoutView.as_view(), name='logout'),
    path('auth/me/', MeView.as_view(), name='me'),
    path('me/', MeView.as_view(), name='me_legacy'),
    path('health/', HealthView.as_view(), name='health'),
    path('health/live/', HealthView.as_view(), name='health_live'),
    path('health/ready/', HealthView.as_view(), name='health_ready'),
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('stats/dashboard/', DashboardStatsView.as_view(), name='dashboard_stats'),
    path('reports/', ReportsView.as_view(), name='reports'),
] + router.urls
