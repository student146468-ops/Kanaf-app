from django.db import models

# 1. جدول المتطوعين
class Volunteer(models.Model):
    name = models.CharField(max_length=100)
    specialty = models.CharField(max_length=100)
    points = models.IntegerField(default=0)

    def __str__(self):
        return self.name

# 2. جدول الأيتام
class Orphan(models.Model):
    name = models.CharField(max_length=100)
    age = models.IntegerField()
    status = models.CharField(max_length=100, default='ينتظر كفالة')

    def __str__(self):
        return self.name

# 3. جدول التبرعات
class Donation(models.Model):
    donor_name = models.CharField(max_length=100)
    item_type = models.CharField(max_length=100)
    status = models.CharField(max_length=50, default='قيد التنفيذ')

    def __str__(self):
        return f"{self.donor_name} - {self.item_type}"

# 4. جدول الكفلاء
class Sponsor(models.Model):
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    orphan_name = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return self.name

# 5. جدول إدارة المخزن
class InventoryItem(models.Model):
    item_name = models.CharField(max_length=100)
    quantity = models.IntegerField()

    def __str__(self):
        return self.item_name
