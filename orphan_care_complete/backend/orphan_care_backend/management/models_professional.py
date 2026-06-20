"""
نماذج قاعدة البيانات المحسّنة - نسخة احترافية
"""
from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator


class CustomUser(models.Model):
    """
    نموذج مستخدم مخصص مع دعم الأدوار المختلفة
    """
    ROLE_CHOICES = [
        ('donor', 'متبرع'),
        ('volunteer', 'متطوع'),
        ('care_home', 'دار رعاية'),
        ('admin', 'مسؤول'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='donor')
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    profile_image = models.ImageField(upload_to='profiles/', blank=True, null=True)
    is_verified = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    last_login = models.DateTimeField(blank=True, null=True)

    class Meta:
        verbose_name = 'مستخدم'
        verbose_name_plural = 'مستخدمون'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.get_full_name()} ({self.get_role_display()})"


class Orphan(models.Model):
    """
    نموذج بيانات الأيتام
    """
    STATUS_CHOICES = [
        ('waiting', 'ينتظر كفالة'),
        ('sponsored', 'مكفول'),
        ('graduated', 'متخرج'),
    ]

    name = models.CharField(max_length=100)
    age = models.IntegerField(validators=[MinValueValidator(0), MaxValueValidator(18)])
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='waiting')
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to='orphans/', blank=True, null=True)
    sponsor = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, blank=True, related_name='sponsored_orphans')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'يتيم'
        verbose_name_plural = 'أيتام'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name} ({self.get_status_display()})"


class Donation(models.Model):
    """
    نموذج بيانات التبرعات
    """
    STATUS_CHOICES = [
        ('pending', 'قيد الانتظار'),
        ('in_progress', 'قيد التنفيذ'),
        ('completed', 'مكتملة'),
        ('rejected', 'مرفوضة'),
    ]

    TYPE_CHOICES = [
        ('financial', 'مالية'),
        ('in_kind', 'عينية'),
    ]

    donor = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='donations')
    donation_type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    item_type = models.CharField(max_length=100)
    amount = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'تبرع'
        verbose_name_plural = 'تبرعات'
        ordering = ['-created_at']

    def __str__(self):
        return f"تبرع من {self.donor.user.get_full_name()} - {self.get_donation_type_display()}"


class Volunteer(models.Model):
    """
    نموذج بيانات المتطوعين
    """
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='volunteer_profile')
    specialty = models.CharField(max_length=100)
    experience = models.TextField(blank=True, null=True)
    points = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    hours_worked = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'متطوع'
        verbose_name_plural = 'متطوعون'
        ordering = ['-points']

    def __str__(self):
        return f"{self.user.user.get_full_name()} - {self.specialty}"


class VolunteerOpportunity(models.Model):
    """
    نموذج فرص التطوع المتاحة
    """
    STATUS_CHOICES = [
        ('open', 'مفتوحة'),
        ('closed', 'مغلقة'),
        ('completed', 'مكتملة'),
    ]

    title = models.CharField(max_length=200)
    description = models.TextField()
    required_volunteers = models.IntegerField(default=1)
    current_volunteers = models.IntegerField(default=0)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    location = models.CharField(max_length=200)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='open')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'فرصة تطوع'
        verbose_name_plural = 'فرص التطوع'
        ordering = ['-start_date']

    def __str__(self):
        return self.title


class Sponsor(models.Model):
    """
    نموذج بيانات الكفلاء
    """
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    orphan = models.OneToOneField(Orphan, on_delete=models.SET_NULL, null=True, blank=True, related_name='sponsor_info')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'كفيل'
        verbose_name_plural = 'كفلاء'
        ordering = ['-created_at']

    def __str__(self):
        return self.name


class InventoryItem(models.Model):
    """
    نموذج إدارة المخزن
    """
    item_name = models.CharField(max_length=100)
    category = models.CharField(max_length=50)
    quantity = models.IntegerField(validators=[MinValueValidator(0)])
    unit = models.CharField(max_length=20, default='قطعة')
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to='inventory/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'صنف مخزن'
        verbose_name_plural = 'أصناف المخزن'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.item_name} ({self.quantity} {self.unit})"


class CareHome(models.Model):
    """
    نموذج بيانات دور الرعاية
    """
    name = models.CharField(max_length=200)
    address = models.TextField()
    phone = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    manager = models.ForeignKey(CustomUser, on_delete=models.SET_NULL, null=True, blank=True, related_name='managed_care_homes')
    description = models.TextField(blank=True, null=True)
    image = models.ImageField(upload_to='care_homes/', blank=True, null=True)
    orphan_count = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'دار رعاية'
        verbose_name_plural = 'دور الرعاية'
        ordering = ['-created_at']

    def __str__(self):
        return self.name


class Notification(models.Model):
    """
    نموذج الإشعارات
    """
    NOTIFICATION_TYPES = [
        ('donation', 'تبرع'),
        ('volunteer', 'تطوع'),
        ('status_update', 'تحديث حالة'),
        ('message', 'رسالة'),
    ]

    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='notifications')
    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES)
    title = models.CharField(max_length=200)
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'إشعار'
        verbose_name_plural = 'إشعارات'
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.title} - {self.user.user.get_full_name()}"
