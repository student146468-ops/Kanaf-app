from django.urls import path
from . import views

urlpatterns = [
    # 1. الصفحة الرئيسية
    path('', views.dashboard, name='dashboard'),

    # 2. صفحة الأيتام
    path('orphans/', views.orphans_list, name='orphans_list'),

    # 3. صفحة المتطوعين
    path('volunteers/', views.volunteers_view, name='volunteers_list'),

    # 4. صفحة التبرعات
    path('donations/', views.donations_list, name='donations_list'),

    # 5. صفحة الكفلاء
    path('sponsors/', views.sponsors_list, name='sponsors_list'),

    # 6. صفحة المخزن
    path('inventory/', views.inventory_view, name='inventory_view'),

    # 7. صفحة التقارير
    path('reports/', views.reports_view, name='reports_view'),

    # 8. صفحة الإعدادات
    path('settings/', views.settings_view, name='settings_view'),

    path('delete_orphan/<int:pk>/', views.delete_orphan, name='delete_orphan'),
    path('delete_volunteer/<int:pk>/', views.delete_volunteer, name='delete_volunteer'),
    path('delete_donation/<int:pk>/', views.delete_donation, name='delete_donation'),
    path('delete_sponsor/<int:pk>/', views.delete_sponsor, name='delete_sponsor'),
    path('delete_inventory/<int:pk>/', views.delete_inventory, name='delete_inventory'),
    path('api/orphans/', views.orphans_api, name='orphans_api'),
    path('api/donations/', views.donations_api, name='donations_api'),
    path('dashboard/api/', views.api_dashboard, name='api_dashboard'),

 
]