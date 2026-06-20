"""
Serializers المحسّنة للمنظومة - نسخة احترافية
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from .models_professional import (
    CustomUser, Orphan, Donation, Volunteer, VolunteerOpportunity,
    Sponsor, InventoryItem, CareHome, Notification
)


class UserSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج المستخدم الافتراضي
    """
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']


class CustomUserSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج المستخدم المخصص
    """
    user = UserSerializer(read_only=True)
    
    class Meta:
        model = CustomUser
        fields = ['id', 'user', 'role', 'phone_number', 'profile_image', 'is_verified', 'created_at']
        read_only_fields = ['created_at', 'updated_at']


class UserRegistrationSerializer(serializers.Serializer):
    """
    Serializer لتسجيل مستخدم جديد (بدون OTP)
    """
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirm = serializers.CharField(write_only=True, min_length=8)
    first_name = serializers.CharField(max_length=100)
    last_name = serializers.CharField(max_length=100)
    role = serializers.ChoiceField(choices=['donor', 'volunteer', 'care_home'])
    phone_number = serializers.CharField(max_length=20, required=False)

    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({'password': 'كلمات المرور غير متطابقة'})
        
        if User.objects.filter(email=data['email']).exists():
            raise serializers.ValidationError({'email': 'البريد الإلكتروني مسجل بالفعل'})
        
        return data

    def create(self, validated_data):
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')
        phone_number = validated_data.pop('phone_number', '')
        role = validated_data.pop('role')

        # إنشاء مستخدم جديد
        user = User.objects.create_user(
            username=validated_data['email'],
            email=validated_data['email'],
            password=password,
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name'],
        )

        # إنشاء مستخدم مخصص
        custom_user = CustomUser.objects.create(
            user=user,
            role=role,
            phone_number=phone_number,
        )

        return custom_user


class UserLoginSerializer(serializers.Serializer):
    """
    Serializer لتسجيل الدخول (بدون OTP)
    """
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        try:
            user = User.objects.get(email=data['email'])
            if not user.check_password(data['password']):
                raise serializers.ValidationError({'password': 'كلمة المرور غير صحيحة'})
        except User.DoesNotExist:
            raise serializers.ValidationError({'email': 'البريد الإلكتروني غير مسجل'})
        
        return data


class OrphanSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج الأيتام
    """
    class Meta:
        model = Orphan
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']


class DonationSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج التبرعات
    """
    donor_name = serializers.CharField(source='donor.user.get_full_name', read_only=True)
    
    class Meta:
        model = Donation
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at', 'donor']


class VolunteerSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج المتطوعين
    """
    user_name = serializers.CharField(source='user.user.get_full_name', read_only=True)
    
    class Meta:
        model = Volunteer
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']


class VolunteerOpportunitySerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج فرص التطوع
    """
    class Meta:
        model = VolunteerOpportunity
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at', 'current_volunteers']


class SponsorSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج الكفلاء
    """
    class Meta:
        model = Sponsor
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']


class InventorySerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج المخزن
    """
    class Meta:
        model = InventoryItem
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']


class CareHomeSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج دور الرعاية
    """
    manager_name = serializers.CharField(source='manager.user.get_full_name', read_only=True)
    
    class Meta:
        model = CareHome
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']


class NotificationSerializer(serializers.ModelSerializer):
    """
    Serializer لنموذج الإشعارات
    """
    class Meta:
        model = Notification
        fields = '__all__'
        read_only_fields = ['created_at']
