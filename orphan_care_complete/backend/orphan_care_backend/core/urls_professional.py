"""Compatibility URL module for older professional-backend deployments."""
from django.urls import include, path

from management.views_professional import AuthenticationView

urlpatterns = [
    path('auth/login/', AuthenticationView.as_view(), name='professional_login'),
    path('auth/register/', AuthenticationView.as_view(), name='professional_register'),
    path('', include('core.urls_api')),
]
