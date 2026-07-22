"""Compatibility views for the former professional backend module."""
from .views_api import (
    CareHomeViewSet,
    DashboardStatsView,
    DonationViewSet,
    InventoryViewSet,
    LoginView,
    NotificationViewSet,
    OrphanViewSet,
    RegisterView,
    ReportsView,
    SponsorViewSet,
    VolunteerApplicationViewSet,
    VolunteerOpportunityViewSet,
    VolunteerViewSet,
)


class AuthenticationView(LoginView):
    """Backward-compatible login/register view.

    Older clients may post {"action": "login"} or {"action": "register"} to
    this single endpoint. New clients should use the active /api/auth/* routes.
    """

    def post(self, request):
        if request.data.get('action') == 'register':
            return RegisterView().post(request)
        return super().post(request)
