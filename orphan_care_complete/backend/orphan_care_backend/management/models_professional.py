"""Compatibility aliases for the former professional backend module.

The active, migrated models live in management.models. Keeping these aliases
prevents old imports from breaking without registering duplicate model classes.
"""
from .models import (
    CareHome,
    Donation,
    InventoryItem,
    Notification,
    Orphan,
    Sponsor,
    UserProfile,
    Volunteer,
    VolunteerApplication,
    VolunteerOpportunity,
)

CustomUser = UserProfile
