from django.contrib.auth import get_user_model
from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from management.models import (
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


class AuthApiTests(APITestCase):
    def test_health_endpoint_reports_database(self):
        response = self.client.get(reverse('health'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.json()['status'], 'ok')
        self.assertEqual(response.json()['database'], 'ok')

    def test_register_endpoint_creates_user(self):
        url = reverse('register')
        data = {
            'username': 'newuser',
            'email': 'newuser@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!'
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(get_user_model().objects.filter(username='newuser').exists())

    def test_orphan_list_requires_authentication(self):
        url = reverse('orphan-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_me_endpoint_returns_authenticated_user(self):
        user = get_user_model().objects.create_user(username='profileuser', email='profile@example.com', password='StrongPass123!')
        self.client.force_authenticate(user=user)
        response = self.client.get(reverse('me'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.json()['username'], 'profileuser')

    def test_login_accepts_email_and_returns_frontend_token_aliases(self):
        get_user_model().objects.create_user(username='emailuser', email='emailuser@example.com', password='StrongPass123!')
        response = self.client.post(reverse('token_obtain_pair'), {
            'email': 'emailuser@example.com',
            'password': 'StrongPass123!',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        body = response.json()
        self.assertIn('access', body)
        self.assertIn('refresh', body)
        self.assertIn('token', body)
        self.assertIn('user', body)

    def test_orphan_list_returns_array_for_frontend_compatibility(self):
        user = get_user_model().objects.create_user(username='listuser', password='StrongPass123!')
        Orphan.objects.create(name='Test Orphan', age=9)
        self.client.force_authenticate(user=user)
        response = self.client.get(reverse('orphan-list'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsInstance(response.json(), list)

    def test_invalid_orphan_age_is_rejected(self):
        user = get_user_model().objects.create_user(username='invalidageuser', password='StrongPass123!')
        self.client.force_authenticate(user=user)
        response = self.client.post(reverse('orphan-list'), {'name': 'Invalid Age', 'age': 19}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_hyphenated_my_donations_route_is_available(self):
        user = get_user_model().objects.create_user(username='donoruser', password='StrongPass123!')
        Donation.objects.create(donor_name='donoruser', item_type='Food')
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/donations/my-donations/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.json()), 1)

    def test_volunteer_opportunities_endpoint_is_frontend_compatible(self):
        user = get_user_model().objects.create_user(username='volunteeruser', password='StrongPass123!')
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/volunteer-opportunities/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsInstance(response.json(), list)

    def test_register_creates_role_profile(self):
        response = self.client.post(reverse('register'), {
            'username': 'roleuser',
            'email': 'roleuser@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': 'volunteer',
            'phone_number': '0912345678',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        user = get_user_model().objects.get(username='roleuser')
        self.assertEqual(user.profile.role, UserProfile.ROLE_VOLUNTEER)
        self.assertEqual(response.json()['user']['role'], UserProfile.ROLE_VOLUNTEER)

    def test_invalid_role_is_rejected(self):
        response = self.client.post(reverse('register'), {
            'username': 'badrole',
            'email': 'badrole@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': 'owner',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_care_home_crud_endpoint(self):
        user = get_user_model().objects.create_user(username='carehomeuser', password='StrongPass123!')
        self.client.force_authenticate(user=user)
        response = self.client.post('/api/care-homes/', {
            'name': 'Kanaf Home',
            'address': 'Tripoli',
            'phone': '0912345678',
            'orphan_count': 3,
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(CareHome.objects.filter(name='Kanaf Home').exists())

    def test_volunteer_opportunity_crud_endpoint(self):
        user = get_user_model().objects.create_user(username='opportunityuser', password='StrongPass123!')
        self.client.force_authenticate(user=user)
        response = self.client.post('/api/volunteer-opportunities/', {
            'title': 'Teaching support',
            'description': 'Weekly tutoring',
            'required_volunteers': 2,
            'location': 'Kanaf Home',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.json()['current_volunteers'], 0)

    def test_apply_to_volunteer_opportunity_is_duplicate_safe(self):
        user = get_user_model().objects.create_user(username='applyuser', password='StrongPass123!')
        opportunity = VolunteerOpportunity.objects.create(
            title='Visit support',
            description='Help organize a visit',
            required_volunteers=1,
        )
        self.client.force_authenticate(user=user)
        first = self.client.post(f'/api/volunteer-opportunities/{opportunity.id}/apply/', {'message': 'I can help'}, format='json')
        second = self.client.post(f'/api/volunteer-opportunities/{opportunity.id}/apply/', {'message': 'Again'}, format='json')
        self.assertEqual(first.status_code, status.HTTP_201_CREATED)
        self.assertEqual(second.status_code, status.HTTP_200_OK)
        self.assertEqual(VolunteerApplication.objects.filter(opportunity=opportunity, user=user).count(), 1)

    def test_only_staff_can_approve_volunteer_application(self):
        user = get_user_model().objects.create_user(username='approvaluser', password='StrongPass123!')
        opportunity = VolunteerOpportunity.objects.create(title='Food packing', description='Pack donated food')
        application = VolunteerApplication.objects.create(opportunity=opportunity, user=user)
        self.client.force_authenticate(user=user)
        response = self.client.post(f'/api/volunteer-applications/{application.id}/approve/')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_staff_approval_updates_opportunity_count(self):
        user = get_user_model().objects.create_user(username='approveduser', password='StrongPass123!')
        staff = get_user_model().objects.create_user(username='staffuser', password='StrongPass123!', is_staff=True)
        opportunity = VolunteerOpportunity.objects.create(title='Tutoring', description='Math tutoring', required_volunteers=1)
        application = VolunteerApplication.objects.create(opportunity=opportunity, user=user)
        self.client.force_authenticate(user=staff)
        response = self.client.post(f'/api/volunteer-applications/{application.id}/approve/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        application.refresh_from_db()
        opportunity.refresh_from_db()
        self.assertEqual(application.status, VolunteerApplication.STATUS_APPROVED)
        self.assertEqual(opportunity.current_volunteers, 1)

    def test_notifications_are_scoped_to_current_user(self):
        user = get_user_model().objects.create_user(username='notifyuser', password='StrongPass123!')
        other = get_user_model().objects.create_user(username='othernotify', password='StrongPass123!')
        Notification.objects.create(user=user, title='Mine', message='Visible')
        Notification.objects.create(user=other, title='Other', message='Hidden')
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/notifications/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.json()), 1)
        self.assertEqual(response.json()[0]['title'], 'Mine')

    def test_notification_mark_as_read(self):
        user = get_user_model().objects.create_user(username='readuser', password='StrongPass123!')
        notification = Notification.objects.create(user=user, title='Read me', message='Message')
        self.client.force_authenticate(user=user)
        response = self.client.post(f'/api/notifications/{notification.id}/mark_as_read/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        notification.refresh_from_db()
        self.assertTrue(notification.is_read)

    def test_profiles_are_scoped_to_current_user(self):
        user = get_user_model().objects.create_user(username='profileowner', password='StrongPass123!')
        other = get_user_model().objects.create_user(username='profileother', password='StrongPass123!')
        UserProfile.objects.create(user=user)
        UserProfile.objects.create(user=other)
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/profiles/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.json()), 1)
        self.assertEqual(response.json()[0]['username'], 'profileowner')


class ManagementModelTests(TestCase):
    def test_create_orphan(self):
        orphan = Orphan.objects.create(name='أحمد', age=10, status='ينتظر كفالة')
        self.assertEqual(orphan.name, 'أحمد')

    def test_create_inventory_item(self):
        item = InventoryItem.objects.create(item_name='أغذية', quantity=5)
        self.assertEqual(item.quantity, 5)

    def test_create_donation(self):
        donation = Donation.objects.create(donor_name='سارة', item_type='ملابس', status='قيد التنفيذ')
        self.assertEqual(donation.status, 'قيد التنفيذ')

    def test_create_sponsor_and_volunteer(self):
        sponsor = Sponsor.objects.create(name='خالد', phone='0912345678')
        volunteer = Volunteer.objects.create(name='ليلى', specialty='تدريس', points=10)
        self.assertTrue(sponsor.pk)
        self.assertEqual(volunteer.points, 10)
