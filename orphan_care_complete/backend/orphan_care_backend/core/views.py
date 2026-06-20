from django.shortcuts import render, redirect
from management.models import Volunteer, Donation, Orphan, Sponsor, InventoryItem

# 1. الصفحة الرئيسية (Dashboard)
def dashboard(request):
    context = {
        'total_orphans': Orphan.objects.count(),
        'total_donations': Donation.objects.count(),
        'total_volunteers': Volunteer.objects.count(),
    }
    return render(request, 'dashboard.html', context)

# 2. صفحة الأيتام (عرض وحفظ)
def orphans_list(request):
    if request.method == "POST":
        Orphan.objects.create(
            name=request.POST.get('o_name'),
            age=request.POST.get('o_age')
        )
        return redirect('orphans_list')
    return render(request, 'orphans.html', {'orphans': Orphan.objects.all(), 'total_count': Orphan.objects.count()})

# 3. صفحة المتطوعين (عرض وحفظ)
def volunteers_view(request):
    if request.method == "POST":
        Volunteer.objects.create(
            name=request.POST.get('v_name'),
            specialty=request.POST.get('v_specialty')
        )
        return redirect('volunteers_list')
    return render(request, 'volunteers.html', {'volunteers': Volunteer.objects.all(), 'total_count': Volunteer.objects.count()})

# 4. صفحة التبرعات (عرض وحفظ)
def donations_list(request):
    if request.method == "POST":
        Donation.objects.create(
            donor_name=request.POST.get('d_name'),
            item_type=request.POST.get('d_item')
        )
        return redirect('donations_list')
    return render(request, 'donations.html', {'donations': Donation.objects.all()})

# 5. صفحة الكفلاء (عرض وحفظ)
def sponsors_list(request):
    if request.method == "POST":
        Sponsor.objects.create(
            name=request.POST.get('s_name'),
            phone=request.POST.get('s_phone')
        )
        return redirect('sponsors_list')
    return render(request, 'sponsors.html', {'sponsors': Sponsor.objects.all()})

# 6. صفحة إدارة المخزن (عرض وحفظ)
def inventory_view(request):
    if request.method == "POST":
        InventoryItem.objects.create(
            item_name=request.POST.get('i_name'),
            quantity=request.POST.get('i_qty')
        )
        return redirect('inventory_view')
    return render(request, 'inventory.html', {'items': InventoryItem.objects.all()})

# 7. صفحة التقارير (إحصائيات شاملة)
def reports_view(request):
    context = {
        'total_orphans': Orphan.objects.count(),
        'total_donations': Donation.objects.count(),
        'total_volunteers': Volunteer.objects.count(),
        'total_sponsors': Sponsor.objects.count(),
        'total_items': InventoryItem.objects.count(),
    }
    return render(request, 'reports.html', context)

# 8. صفحة الإعدادات (عرض)
def settings_view(request):
    return render(request, 'settings.html')
def reports_view(request):
    context = {
        'total_orphans': Orphan.objects.count(),
        'total_volunteers': Volunteer.objects.count(),
        'total_donations': Donation.objects.count(),
        'total_sponsors': Sponsor.objects.count(),
        'total_items': InventoryItem.objects.count(),
    }
    return render(request, 'reports.html', context)
# حذف يتيم
def delete_orphan(request, pk):
    Orphan.objects.get(id=pk).delete()
    return redirect('orphans_list')

# حذف متطوع
def delete_volunteer(request, pk):
    Volunteer.objects.get(id=pk).delete()
    return redirect('volunteers_list')

# حذف تبرع
def delete_donation(request, pk):
    Donation.objects.get(id=pk).delete()
    return redirect('donations_list')

# حذف كفيل
def delete_sponsor(request, pk):
    Sponsor.objects.get(id=pk).delete()
    return redirect('sponsors_list')

# حذف صنف من المخزن
def delete_inventory(request, pk):
    InventoryItem.objects.get(id=pk).delete()
    return redirect('inventory_view')
from rest_framework.decorators import api_view
from rest_framework.response import Response
from management.serializers import OrphanSerializer, DonationSerializer

@api_view(['GET'])
def orphans_api(request):
    orphans = Orphan.objects.all()
    serializer = OrphanSerializer(orphans, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def donations_api(request):
    donations = Donation.objects.all()
    serializer = DonationSerializer(donations, many=True)
    return Response(serializer.data)
def api_dashboard(request):
    import json
    from management.serializers import OrphanSerializer, DonationSerializer
    
    # تحويل البيانات لـ JSON نصي عشان نعرضوه في اللوحة
    orphans_data = OrphanSerializer(Orphan.objects.all(), many=True).data
    donations_data = DonationSerializer(Donation.objects.all(), many=True).data
    
    context = {
        'orphans_json': json.dumps(orphans_data, indent=4, ensure_ascii=False),
        'donations_json': json.dumps(donations_data, indent=4, ensure_ascii=False),
    }
    return render(request, 'api_dashboard.html', context)