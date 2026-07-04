"""Compatibility serializers for the former professional backend module."""
from django.contrib.auth import get_user_model
from rest_framework import serializers

from .serializers import (
    CareHomeSerializer,
    DonationSerializer,
    InventorySerializer,
    NotificationSerializer,
    OrphanSerializer,
    SponsorSerializer,
    UserProfileSerializer,
    VolunteerApplicationSerializer,
    VolunteerOpportunitySerializer,
    VolunteerSerializer,
)

User = get_user_model()
CustomUserSerializer = UserProfileSerializer


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']


class UserRegistrationSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True, min_length=8)
    first_name = serializers.CharField(max_length=100, required=False, allow_blank=True)
    last_name = serializers.CharField(max_length=100, required=False, allow_blank=True)
    role = serializers.ChoiceField(choices=['donor', 'volunteer', 'care_home'], required=False)
    phone_number = serializers.CharField(max_length=20, required=False, allow_blank=True)

    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({'password': 'passwords do not match'})
        if User.objects.filter(email__iexact=data['email']).exists():
            raise serializers.ValidationError({'email': 'email already exists'})
        return data


class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)
