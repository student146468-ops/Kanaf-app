import json

from django.contrib.admin.views.decorators import staff_member_required
from django.shortcuts import get_object_or_404, redirect, render
from rest_framework.decorators import api_view
from rest_framework.response import Response

from management.models import Donation, InventoryItem, Orphan, Sponsor, Volunteer
from management.serializers import DonationSerializer, InventorySerializer, OrphanSerializer, SponsorSerializer, VolunteerSerializer


def _save_from_serializer(request, serializer_class, data, redirect_name, template_name, context):
    serializer = serializer_class(data=data)
    if serializer.is_valid():
        serializer.save()
        return redirect(redirect_name)
    context['form_errors'] = serializer.errors
    return render(request, template_name, context)


@staff_member_required
def dashboard(request):
    context = {
        'total_orphans': Orphan.objects.count(),
        'total_donations': Donation.objects.count(),
        'total_volunteers': Volunteer.objects.count(),
    }
    return render(request, 'dashboard.html', context)


@staff_member_required
def orphans_list(request):
    context = {'orphans': Orphan.objects.all(), 'total_count': Orphan.objects.count()}
    if request.method == 'POST':
        return _save_from_serializer(
            request,
            OrphanSerializer,
            {'name': request.POST.get('o_name'), 'age': request.POST.get('o_age')},
            'orphans_list',
            'orphans.html',
            context,
        )
    return render(request, 'orphans.html', context)


@staff_member_required
def volunteers_view(request):
    context = {'volunteers': Volunteer.objects.all(), 'total_count': Volunteer.objects.count()}
    if request.method == 'POST':
        return _save_from_serializer(
            request,
            VolunteerSerializer,
            {'name': request.POST.get('v_name'), 'specialty': request.POST.get('v_specialty')},
            'volunteers_list',
            'volunteers.html',
            context,
        )
    return render(request, 'volunteers.html', context)


@staff_member_required
def donations_list(request):
    context = {'donations': Donation.objects.all()}
    if request.method == 'POST':
        return _save_from_serializer(
            request,
            DonationSerializer,
            {'donor_name': request.POST.get('d_name'), 'item_type': request.POST.get('d_item')},
            'donations_list',
            'donations.html',
            context,
        )
    return render(request, 'donations.html', context)


@staff_member_required
def sponsors_list(request):
    context = {'sponsors': Sponsor.objects.all()}
    if request.method == 'POST':
        return _save_from_serializer(
            request,
            SponsorSerializer,
            {'name': request.POST.get('s_name'), 'phone': request.POST.get('s_phone')},
            'sponsors_list',
            'sponsors.html',
            context,
        )
    return render(request, 'sponsors.html', context)


@staff_member_required
def inventory_view(request):
    context = {'items': InventoryItem.objects.all()}
    if request.method == 'POST':
        return _save_from_serializer(
            request,
            InventorySerializer,
            {'item_name': request.POST.get('i_name'), 'quantity': request.POST.get('i_qty')},
            'inventory_view',
            'inventory.html',
            context,
        )
    return render(request, 'inventory.html', context)


@staff_member_required
def reports_view(request):
    context = {
        'total_orphans': Orphan.objects.count(),
        'total_volunteers': Volunteer.objects.count(),
        'total_donations': Donation.objects.count(),
        'total_sponsors': Sponsor.objects.count(),
        'total_items': InventoryItem.objects.count(),
    }
    return render(request, 'reports.html', context)


@staff_member_required
def settings_view(request):
    return render(request, 'settings.html')


@staff_member_required
def delete_orphan(request, pk):
    get_object_or_404(Orphan, id=pk).delete()
    return redirect('orphans_list')


@staff_member_required
def delete_volunteer(request, pk):
    get_object_or_404(Volunteer, id=pk).delete()
    return redirect('volunteers_list')


@staff_member_required
def delete_donation(request, pk):
    get_object_or_404(Donation, id=pk).delete()
    return redirect('donations_list')


@staff_member_required
def delete_sponsor(request, pk):
    get_object_or_404(Sponsor, id=pk).delete()
    return redirect('sponsors_list')


@staff_member_required
def delete_inventory(request, pk):
    get_object_or_404(InventoryItem, id=pk).delete()
    return redirect('inventory_view')


@api_view(['GET'])
def orphans_api(request):
    serializer = OrphanSerializer(Orphan.objects.all(), many=True)
    return Response(serializer.data)


@api_view(['GET'])
def donations_api(request):
    serializer = DonationSerializer(Donation.objects.all(), many=True)
    return Response(serializer.data)


@staff_member_required
def api_dashboard(request):
    orphans_data = OrphanSerializer(Orphan.objects.all(), many=True).data
    donations_data = DonationSerializer(Donation.objects.all(), many=True).data
    context = {
        'orphans_json': json.dumps(orphans_data, indent=4, ensure_ascii=False),
        'donations_json': json.dumps(donations_data, indent=4, ensure_ascii=False),
    }
    return render(request, 'api_dashboard.html', context)
