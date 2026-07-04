from rest_framework import serializers

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


def _validate_required_text(value, field_name):
    if value is None or not str(value).strip():
        raise serializers.ValidationError(f'{field_name} is required.')
    return str(value).strip()


class OrphanSerializer(serializers.ModelSerializer):
    class Meta:
        model = Orphan
        fields = '__all__'

    def validate_name(self, value):
        return _validate_required_text(value, 'name')

    def validate_age(self, value):
        if value is None or value < 0 or value > 18:
            raise serializers.ValidationError('age must be between 0 and 18.')
        return value


class DonationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Donation
        fields = '__all__'

    def validate_donor_name(self, value):
        return _validate_required_text(value, 'donor_name')

    def validate_item_type(self, value):
        return _validate_required_text(value, 'item_type')


class VolunteerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Volunteer
        fields = '__all__'

    def validate_name(self, value):
        return _validate_required_text(value, 'name')

    def validate_specialty(self, value):
        return _validate_required_text(value, 'specialty')

    def validate_points(self, value):
        if value is None or value < 0:
            raise serializers.ValidationError('points must be zero or greater.')
        return value


class InventorySerializer(serializers.ModelSerializer):
    class Meta:
        model = InventoryItem
        fields = '__all__'

    def validate_item_name(self, value):
        return _validate_required_text(value, 'item_name')

    def validate_quantity(self, value):
        if value is None or value < 0:
            raise serializers.ValidationError('quantity must be zero or greater.')
        return value


class SponsorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sponsor
        fields = '__all__'

    def validate_name(self, value):
        return _validate_required_text(value, 'name')

    def validate_phone(self, value):
        return _validate_required_text(value, 'phone')


class UserProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    email = serializers.EmailField(source='user.email', read_only=True)

    class Meta:
        model = UserProfile
        fields = ['id', 'username', 'email', 'role', 'phone_number', 'is_verified', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at', 'is_verified']


class VolunteerOpportunitySerializer(serializers.ModelSerializer):
    applications_count = serializers.SerializerMethodField()

    class Meta:
        model = VolunteerOpportunity
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at', 'current_volunteers']

    def validate_title(self, value):
        return _validate_required_text(value, 'title')

    def validate_description(self, value):
        return _validate_required_text(value, 'description')

    def validate(self, attrs):
        start_date = attrs.get('start_date', getattr(self.instance, 'start_date', None))
        end_date = attrs.get('end_date', getattr(self.instance, 'end_date', None))
        if start_date and end_date and end_date < start_date:
            raise serializers.ValidationError({'end_date': 'end_date must be after start_date.'})
        return attrs

    def get_applications_count(self, obj) -> int:
        return obj.applications.count()


class VolunteerApplicationSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    opportunity_title = serializers.CharField(source='opportunity.title', read_only=True)

    class Meta:
        model = VolunteerApplication
        fields = '__all__'
        read_only_fields = ['user', 'created_at', 'updated_at']


class CareHomeSerializer(serializers.ModelSerializer):
    manager_username = serializers.CharField(source='manager.username', read_only=True)

    class Meta:
        model = CareHome
        fields = '__all__'
        read_only_fields = ['created_at', 'updated_at']

    def validate_name(self, value):
        return _validate_required_text(value, 'name')

    def validate_address(self, value):
        return _validate_required_text(value, 'address')

    def validate_phone(self, value):
        return _validate_required_text(value, 'phone')


class NotificationSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Notification
        fields = '__all__'
        read_only_fields = ['created_at', 'user']

    def validate_title(self, value):
        return _validate_required_text(value, 'title')

    def validate_message(self, value):
        return _validate_required_text(value, 'message')
