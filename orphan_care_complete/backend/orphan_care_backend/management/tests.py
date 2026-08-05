import re

from django.contrib.auth import get_user_model
from django.conf import settings
from django.test import Client, TestCase, override_settings
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient, APITestCase

from management.models import (
    CareHome,
    Donation,
    InventoryItem,
    Need,
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

    def test_pythonanywhere_host_is_allowed(self):
        self.assertIn('kanafapp.pythonanywhere.com', settings.ALLOWED_HOSTS)

        response = self.client.get(
            reverse('health'),
            HTTP_HOST='kanafapp.pythonanywhere.com',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_flutter_web_dynamic_localhost_origin_is_allowed(self):
        response = self.client.get(
            reverse('health'),
            HTTP_ORIGIN='http://localhost:59933',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(
            response['access-control-allow-origin'],
            'http://localhost:59933',
        )

    def test_register_endpoint_creates_user(self):
        url = reverse('register')
        data = {
            'username': 'newuser',
            'email': 'newuser@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'phone_number': '0912345678',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(get_user_model().objects.filter(username='newuser').exists())

    def test_register_rejects_duplicate_email_with_email_error(self):
        get_user_model().objects.create_user(
            username='duplicate-email',
            email='duplicate@example.com',
            password='StrongPass123!',
        )

        response = self.client.post(reverse('register'), {
            'username': 'duplicate@example.com',
            'email': 'duplicate@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': UserProfile.ROLE_DONOR,
            'phone_number': '0911111111',
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.json())
        self.assertNotIn('phone_number', response.json())

    def test_register_rejects_duplicate_phone_with_phone_error(self):
        user = get_user_model().objects.create_user(
            username='phone-owner',
            email='phone-owner@example.com',
            password='StrongPass123!',
        )
        UserProfile.objects.create(
            user=user,
            role=UserProfile.ROLE_DONOR,
            phone_number='0922222222',
        )

        response = self.client.post(reverse('register'), {
            'username': 'fresh-phone@example.com',
            'email': 'fresh-phone@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': UserProfile.ROLE_VOLUNTEER,
            'phone_number': '0922222222',
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('phone_number', response.json())
        self.assertNotIn('email', response.json())

    def test_flutter_register_path_is_available(self):
        response = self.client.post('/api/auth/register/', {
            'username': 'pathuser',
            'email': 'pathuser@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': UserProfile.ROLE_DONOR,
            'phone_number': '0912345678',
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('access', response.json())
        self.assertIn('user', response.json())

    def test_flutter_login_path_is_available(self):
        get_user_model().objects.create_user(
            username='pathlogin',
            email='pathlogin@example.com',
            password='StrongPass123!',
        )
        response = self.client.post('/api/auth/login/', {
            'email': 'pathlogin@example.com',
            'password': 'StrongPass123!',
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.json())
        self.assertIn('token', response.json())

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
        Donation.objects.create(user=user, donor_name='donoruser', item_type='Food')
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
            'phone_number': '0912345678',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_care_home_role_registration_is_rejected(self):
        response = self.client.post(reverse('register'), {
            'username': 'carehomerole',
            'email': 'carehomerole@example.com',
            'password': 'StrongPass123!',
            'password_confirm': 'StrongPass123!',
            'role': UserProfile.ROLE_CARE_HOME,
            'phone_number': '0912345678',
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_register_accepts_valid_phone_prefixes(self):
        valid_phone_numbers = [
            '0911234567',
            '0921234567',
            '0931234567',
            '0941234567',
        ]

        for index, phone_number in enumerate(valid_phone_numbers):
            with self.subTest(phone_number=phone_number):
                response = self.client.post(reverse('register'), {
                    'username': f'validphone{index}',
                    'email': f'validphone{index}@example.com',
                    'password': 'Kanaf2026',
                    'password_confirm': 'Kanaf2026',
                    'role': UserProfile.ROLE_DONOR,
                    'phone_number': phone_number,
                }, format='json')

                self.assertEqual(response.status_code, status.HTTP_201_CREATED)
                user = get_user_model().objects.get(username=f'validphone{index}')
                self.assertEqual(user.profile.phone_number, phone_number)

    def test_register_rejects_invalid_phone_numbers(self):
        invalid_phone_numbers = [
            '0951234567',
            '0901234567',
            '091123456',
            '09112345678',
            '09112ABC67',
        ]

        for index, phone_number in enumerate(invalid_phone_numbers):
            with self.subTest(phone_number=phone_number):
                response = self.client.post(reverse('register'), {
                    'username': f'invalidphone{index}',
                    'email': f'invalidphone{index}@example.com',
                    'password': 'Kanaf2026',
                    'password_confirm': 'Kanaf2026',
                    'role': UserProfile.ROLE_VOLUNTEER,
                    'phone_number': phone_number,
                }, format='json')

                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
                self.assertEqual(
                    response.json()['detail'],
                    'رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ بـ 091 أو 092 أو 093 أو 094.',
                )
                self.assertFalse(get_user_model().objects.filter(username=f'invalidphone{index}').exists())

    def test_register_accepts_valid_passwords(self):
        valid_passwords = [
            'Kanaf2026',
            'Student123',
            'abc12345',
        ]

        for index, password in enumerate(valid_passwords):
            with self.subTest(password=password):
                response = self.client.post(reverse('register'), {
                    'username': f'validpassword{index}',
                    'email': f'validpassword{index}@example.com',
                    'password': password,
                    'password_confirm': password,
                    'role': UserProfile.ROLE_DONOR,
                    'phone_number': f'091123456{index}',
                }, format='json')

                self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_register_rejects_invalid_passwords(self):
        invalid_passwords = [
            '12345678',
            'abcdefgh',
            'abc123',
        ]

        for index, password in enumerate(invalid_passwords):
            with self.subTest(password=password):
                response = self.client.post(reverse('register'), {
                    'username': f'invalidpassword{index}',
                    'email': f'invalidpassword{index}@example.com',
                    'password': password,
                    'password_confirm': password,
                    'role': UserProfile.ROLE_VOLUNTEER,
                    'phone_number': '0911234567',
                }, format='json')

                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
                self.assertEqual(
                    response.json()['detail'],
                    'كلمة المرور ضعيفة. يجب أن تتكون من 8 خانات على الأقل وتحتوي على حروف وأرقام.',
                )
                self.assertFalse(get_user_model().objects.filter(username=f'invalidpassword{index}').exists())

    def test_needs_endpoint_returns_real_database_records(self):
        user = get_user_model().objects.create_user(username='needuser', password='StrongPass123!')
        Need.objects.create(
            title='Food support',
            description='Monthly food basket',
            category='food',
            required_quantity='1000',
            fulfilled_quantity=250,
            priority='urgent',
        )
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/needs/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.json()), 1)
        self.assertEqual(response.json()[0]['title'], 'Food support')

    def test_needs_endpoint_hides_verification_records(self):
        user = get_user_model().objects.create_user(username='cleanneeduser', password='StrongPass123!')
        Need.objects.create(
            title='Codex verification need 20260725000301',
            description='Local verification need created through the API.',
            required_quantity='1000',
            fulfilled_quantity=125,
        )
        Need.objects.create(title='Real winter clothes', description='Children need warm clothes')
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/needs/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        titles = [item['title'] for item in response.json()]
        self.assertEqual(titles, ['Real winter clothes'])

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

    def test_volunteer_opportunities_endpoint_hides_verification_records(self):
        user = get_user_model().objects.create_user(username='cleanopportunityuser', password='StrongPass123!')
        VolunteerOpportunity.objects.create(
            title='Codex verification opportunity 20260725000301',
            description='Local verification opportunity created through the API.',
            location='Codex Local Center',
            required_volunteers=2,
        )
        VolunteerOpportunity.objects.create(
            title='Real tutoring opportunity',
            description='Help children with homework',
            location='Kanaf Center',
            required_volunteers=2,
        )
        self.client.force_authenticate(user=user)
        response = self.client.get('/api/volunteer-opportunities/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        titles = [item['title'] for item in response.json()]
        self.assertEqual(titles, ['Real tutoring opportunity'])

    def test_apply_to_volunteer_opportunity_is_duplicate_safe(self):
        user = get_user_model().objects.create_user(username='applyuser', password='StrongPass123!')
        UserProfile.objects.create(user=user, role=UserProfile.ROLE_VOLUNTEER)
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

    def test_financial_donation_flow_is_linked_to_jwt_user_and_need(self):
        donor = get_user_model().objects.create_user(username='DELETE_TEST_DONOR_FLOW', password='StrongPass123!')
        staff = get_user_model().objects.create_user(username='donation-flow-staff', password='StrongPass123!', is_staff=True)
        UserProfile.objects.create(user=donor, role=UserProfile.ROLE_DONOR)
        need = Need.objects.create(title='DELETE_TEST_FINANCIAL_NEED', description='Food support', required_quantity='500')
        self.client.force_authenticate(user=donor)

        create_response = self.client.post('/api/donations/', {
            'donation_type': 'financial',
            'need_id': need.id,
            'amount': '75.50',
            'item_type': 'financial',
            'description': 'Financial test donation',
            'payment_method': 'test gateway',
            'donation_mode': 'one_time',
        }, format='json')

        self.assertEqual(create_response.status_code, status.HTTP_201_CREATED)
        donation_id = create_response.json()['id']
        donation = Donation.objects.get(pk=donation_id)
        self.assertEqual(donation.user, donor)
        self.assertEqual(donation.need, need)
        self.assertEqual(donation.status, Donation.STATUS_PENDING)

        self.client.force_authenticate(user=staff)
        patch_response = self.client.patch(
            f'/api/donations/{donation_id}/',
            {'status': Donation.STATUS_APPROVED},
            format='json',
        )
        self.assertEqual(patch_response.status_code, status.HTTP_200_OK)
        self.assertEqual(patch_response.json()['status'], Donation.STATUS_APPROVED)

        self.client.force_authenticate(user=donor)
        history_response = self.client.get('/api/donations/my-donations/')
        self.assertEqual(history_response.status_code, status.HTTP_200_OK)
        self.assertEqual(history_response.json()[0]['status'], Donation.STATUS_APPROVED)
        self.assertEqual(history_response.json()[0]['need_title'], need.title)
        notifications = self.client.get('/api/notifications/')
        self.assertTrue(any(item['notification_type'] == Notification.TYPE_DONATION for item in notifications.json()))

    def test_in_kind_donation_flow_is_linked_to_jwt_user_and_hidden_from_others(self):
        donor = get_user_model().objects.create_user(username='DELETE_TEST_IN_KIND_DONOR', password='StrongPass123!')
        other = get_user_model().objects.create_user(username='other-donor-flow', password='StrongPass123!')
        UserProfile.objects.create(user=donor, role=UserProfile.ROLE_DONOR)
        UserProfile.objects.create(user=other, role=UserProfile.ROLE_DONOR)
        need = Need.objects.create(title='DELETE_TEST_IN_KIND_NEED', description='Clothes support')
        self.client.force_authenticate(user=donor)

        create_response = self.client.post('/api/donations/', {
            'donation_type': 'in_kind',
            'need_id': need.id,
            'item_type': 'clothes',
            'quantity': '4 boxes',
            'description': 'Winter clothes',
            'contact': '0910000000',
            'notes': 'Available after noon',
        }, format='json')

        self.assertEqual(create_response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(create_response.json()['quantity'], '4 boxes')
        self.assertEqual(create_response.json()['status'], Donation.STATUS_PENDING)

        self.client.force_authenticate(user=other)
        other_history = self.client.get('/api/donations/my-donations/')
        self.assertEqual(other_history.status_code, status.HTTP_200_OK)
        self.assertEqual(other_history.json(), [])

    def test_volunteer_application_status_flow_returns_to_user(self):
        volunteer = get_user_model().objects.create_user(username='DELETE_TEST_VOLUNTEER_FLOW', password='StrongPass123!')
        staff = get_user_model().objects.create_user(username='volunteer-flow-staff', password='StrongPass123!', is_staff=True)
        UserProfile.objects.create(user=volunteer, role=UserProfile.ROLE_VOLUNTEER)
        opportunity = VolunteerOpportunity.objects.create(
            title='DELETE_TEST_VOLUNTEER_OPPORTUNITY_FLOW',
            description='Help with tutoring',
            required_volunteers=2,
        )
        self.client.force_authenticate(user=volunteer)

        create_response = self.client.post(
            f'/api/volunteer-opportunities/{opportunity.id}/apply/',
            {'message': 'I can help every Saturday.'},
            format='json',
        )
        self.assertEqual(create_response.status_code, status.HTTP_201_CREATED)
        application_id = create_response.json()['id']

        self.client.force_authenticate(user=staff)
        complete_response = self.client.post(f'/api/volunteer-applications/{application_id}/complete/')
        self.assertEqual(complete_response.status_code, status.HTTP_200_OK)
        self.assertEqual(complete_response.json()['status'], VolunteerApplication.STATUS_COMPLETED)

        self.client.force_authenticate(user=volunteer)
        history_response = self.client.get('/api/volunteer-applications/my-applications/')
        self.assertEqual(history_response.status_code, status.HTTP_200_OK)
        self.assertEqual(history_response.json()[0]['status'], VolunteerApplication.STATUS_COMPLETED)
        notifications = self.client.get('/api/notifications/')
        self.assertTrue(any(item['notification_type'] == Notification.TYPE_VOLUNTEER for item in notifications.json()))


class DeleteApiTests(APITestCase):
    def setUp(self):
        self.user = get_user_model().objects.create_user(username='delete-api-user', password='StrongPass123!')
        self.staff = get_user_model().objects.create_user(username='delete-api-staff', password='StrongPass123!', is_staff=True)

    def _assert_staff_delete_only(self, url, exists):
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertTrue(exists())

        self.client.force_authenticate(user=self.user)
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertTrue(exists())

        self.client.force_authenticate(user=self.staff)
        response = self.client.delete(url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(exists())

    def test_delete_test_donor_donation_api(self):
        donation = Donation.objects.create(donor_name='DELETE_TEST_DONOR', item_type='Food')
        self._assert_staff_delete_only(
            f'/api/donations/{donation.id}/',
            lambda: Donation.objects.filter(pk=donation.pk).exists(),
        )

    def test_delete_test_volunteer_api(self):
        volunteer = Volunteer.objects.create(name='DELETE_TEST_VOLUNTEER', specialty='Teaching')
        self._assert_staff_delete_only(
            f'/api/volunteers/{volunteer.id}/',
            lambda: Volunteer.objects.filter(pk=volunteer.pk).exists(),
        )

    def test_delete_test_orphan_api(self):
        orphan = Orphan.objects.create(name='DELETE_TEST_ORPHAN', age=8)
        self._assert_staff_delete_only(
            f'/api/orphans/{orphan.id}/',
            lambda: Orphan.objects.filter(pk=orphan.pk).exists(),
        )

    def test_delete_test_need_api_archives_instead_of_hard_delete(self):
        need = Need.objects.create(title='DELETE_TEST_NEED', description='Temporary need')
        self.client.force_authenticate(user=self.staff)

        response = self.client.delete(f'/api/needs/{need.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        need.refresh_from_db()
        self.assertEqual(need.status, Need.STATUS_ARCHIVED)
        self.assertFalse(NeedViewSetQuery.visible_need_exists(need.pk))

    def test_delete_test_volunteer_opportunity_api(self):
        opportunity = VolunteerOpportunity.objects.create(
            title='DELETE_TEST_OPPORTUNITY',
            description='Temporary opportunity',
            required_volunteers=1,
        )
        self._assert_staff_delete_only(
            f'/api/volunteer-opportunities/{opportunity.id}/',
            lambda: VolunteerOpportunity.objects.filter(pk=opportunity.pk).exists(),
        )

    def test_related_volunteer_opportunity_delete_is_blocked_safely(self):
        opportunity = VolunteerOpportunity.objects.create(
            title='DELETE_TEST_RELATED_OPPORTUNITY',
            description='Temporary opportunity with application',
            required_volunteers=1,
        )
        VolunteerApplication.objects.create(opportunity=opportunity, user=self.user)
        self.client.force_authenticate(user=self.staff)

        response = self.client.delete(f'/api/volunteer-opportunities/{opportunity.id}/')

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertTrue(VolunteerOpportunity.objects.filter(pk=opportunity.pk).exists())
        self.assertTrue(VolunteerApplication.objects.filter(opportunity=opportunity).exists())

    def test_notification_delete_is_scoped_to_owner(self):
        other = get_user_model().objects.create_user(username='delete-notification-other', password='StrongPass123!')
        mine = Notification.objects.create(user=self.user, title='DELETE_TEST_NOTIFICATION', message='Mine')
        theirs = Notification.objects.create(user=other, title='DELETE_TEST_NOTIFICATION_OTHER', message='Theirs')
        self.client.force_authenticate(user=self.user)

        other_response = self.client.delete(f'/api/notifications/{theirs.id}/')
        own_response = self.client.delete(f'/api/notifications/{mine.id}/')

        self.assertEqual(other_response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertEqual(own_response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Notification.objects.filter(pk=mine.pk).exists())
        self.assertTrue(Notification.objects.filter(pk=theirs.pk).exists())

    def test_deleting_approved_volunteer_application_updates_opportunity_count(self):
        opportunity = VolunteerOpportunity.objects.create(
            title='DELETE_TEST_APPROVED_APPLICATION_OPPORTUNITY',
            description='Temporary opportunity',
            required_volunteers=2,
            current_volunteers=1,
        )
        application = VolunteerApplication.objects.create(
            opportunity=opportunity,
            user=self.user,
            status=VolunteerApplication.STATUS_APPROVED,
        )
        self.client.force_authenticate(user=self.staff)

        response = self.client.delete(f'/api/volunteer-applications/{application.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(VolunteerApplication.objects.filter(pk=application.pk).exists())
        opportunity.refresh_from_db()
        self.assertEqual(opportunity.current_volunteers, 0)


class NeedViewSetQuery:
    @staticmethod
    def visible_need_exists(pk):
        return Need.objects.exclude(status=Need.STATUS_ARCHIVED).filter(pk=pk).exists()


@override_settings(
    STORAGES={
        'default': {'BACKEND': 'django.core.files.storage.FileSystemStorage'},
        'staticfiles': {'BACKEND': 'django.contrib.staticfiles.storage.StaticFilesStorage'},
    }
)
class ManagementDeleteButtonTests(TestCase):
    def setUp(self):
        self.staff = get_user_model().objects.create_user(
            username='delete-page-staff',
            password='StrongPass123!',
            is_staff=True,
        )
        self.client.force_login(self.staff)

    def _csrf_client(self):
        client = Client(enforce_csrf_checks=True)
        client.force_login(self.staff)
        return client

    def _csrf_token_from(self, response):
        match = re.search(r'name="csrfmiddlewaretoken" value="([^"]+)"', response.content.decode())
        self.assertIsNotNone(match)
        return match.group(1)

    def _assert_management_delete_flow(self, list_name, delete_name, record, exists):
        page_response = self.client.get(reverse(list_name))
        self.assertContains(page_response, 'delete-form')
        self.assertContains(page_response, 'deleteConfirmModal')
        self.assertContains(page_response, 'deleteConfirmCancel')

        get_response = self.client.get(reverse(delete_name, args=[record.pk]), follow=True)
        self.assertEqual(get_response.status_code, 200)
        self.assertTrue(exists())
        self.assertContains(get_response, 'لم تكتمل عملية الحذف')

        no_confirm_response = self.client.post(reverse(delete_name, args=[record.pk]), follow=True)
        self.assertEqual(no_confirm_response.status_code, 200)
        self.assertTrue(exists())
        self.assertContains(no_confirm_response, 'التأكيد مطلوب')

        csrf_client = self._csrf_client()
        csrf_page = csrf_client.get(reverse(list_name))
        csrf_token = self._csrf_token_from(csrf_page)
        delete_response = csrf_client.post(
            reverse(delete_name, args=[record.pk]),
            {'confirm_delete': 'yes', 'csrfmiddlewaretoken': csrf_token},
            follow=True,
        )

        self.assertEqual(delete_response.status_code, 200)
        self.assertFalse(exists())
        self.assertContains(delete_response, 'بنجاح')

    def test_delete_test_orphan_button_flow(self):
        orphan = Orphan.objects.create(name='DELETE_TEST_ORPHAN_PAGE', age=6)
        self._assert_management_delete_flow(
            'orphans_list',
            'delete_orphan',
            orphan,
            lambda: Orphan.objects.filter(pk=orphan.pk).exists(),
        )

    def test_delete_test_volunteer_button_flow(self):
        volunteer = Volunteer.objects.create(name='DELETE_TEST_VOLUNTEER_PAGE', specialty='Teaching')
        self._assert_management_delete_flow(
            'volunteers_list',
            'delete_volunteer',
            volunteer,
            lambda: Volunteer.objects.filter(pk=volunteer.pk).exists(),
        )

    def test_delete_test_donor_donation_button_flow(self):
        donation = Donation.objects.create(donor_name='DELETE_TEST_DONOR_PAGE', item_type='Food')
        self._assert_management_delete_flow(
            'donations_list',
            'delete_donation',
            donation,
            lambda: Donation.objects.filter(pk=donation.pk).exists(),
        )

    def test_delete_test_sponsor_button_flow(self):
        sponsor = Sponsor.objects.create(name='DELETE_TEST_SPONSOR_PAGE', phone='0912345678')
        self._assert_management_delete_flow(
            'sponsors_list',
            'delete_sponsor',
            sponsor,
            lambda: Sponsor.objects.filter(pk=sponsor.pk).exists(),
        )

    def test_delete_test_inventory_button_flow(self):
        item = InventoryItem.objects.create(item_name='DELETE_TEST_INVENTORY_PAGE', quantity=3)
        self._assert_management_delete_flow(
            'inventory_view',
            'delete_inventory',
            item,
            lambda: InventoryItem.objects.filter(pk=item.pk).exists(),
        )


@override_settings(
    STORAGES={
        'default': {'BACKEND': 'django.core.files.storage.FileSystemStorage'},
        'staticfiles': {'BACKEND': 'django.contrib.staticfiles.storage.StaticFilesStorage'},
    }
)
class ManagementStatusUpdateTests(TestCase):
    def setUp(self):
        self.staff = get_user_model().objects.create_user(
            username='status-page-staff',
            password='StrongPass123!',
            is_staff=True,
        )
        self.user = get_user_model().objects.create_user(
            username='status-page-user',
            password='StrongPass123!',
        )
        self.donor = get_user_model().objects.create_user(
            username='status-donor',
            password='StrongPass123!',
        )
        self.volunteer = get_user_model().objects.create_user(
            username='status-volunteer',
            password='StrongPass123!',
        )
        UserProfile.objects.create(user=self.donor, role=UserProfile.ROLE_DONOR)
        UserProfile.objects.create(user=self.volunteer, role=UserProfile.ROLE_VOLUNTEER)
        self.donation = Donation.objects.create(
            user=self.donor,
            donor_name='STATUS_TEST_DONOR',
            donation_type=Donation.TYPE_FINANCIAL,
            amount='25.00',
            status=Donation.STATUS_PENDING,
        )
        self.opportunity = VolunteerOpportunity.objects.create(
            title='STATUS_TEST_OPPORTUNITY',
            description='Temporary opportunity',
            required_volunteers=1,
        )
        self.application = VolunteerApplication.objects.create(
            user=self.volunteer,
            opportunity=self.opportunity,
            message='I can help',
            status=VolunteerApplication.STATUS_PENDING,
        )

    def _staff_client(self):
        client = Client()
        client.force_login(self.staff)
        return client

    def test_staff_can_open_donations_page(self):
        response = self._staff_client().get(reverse('donations_list'))

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'STATUS_TEST_DONOR')
        self.assertContains(response, reverse('update_donation_status', args=[self.donation.pk]))

    def test_staff_can_update_donation_status_to_accepted_with_post(self):
        response = self._staff_client().post(
            reverse('update_donation_status', args=[self.donation.pk]),
            {'status': Donation.STATUS_ACCEPTED},
            follow=True,
        )

        self.assertEqual(response.status_code, 200)
        self.donation.refresh_from_db()
        self.assertEqual(self.donation.status, Donation.STATUS_ACCEPTED)
        self.assertContains(response, 'تم تحديث حالة التبرع إلى مقبول.')

    def test_get_cannot_update_donation_status(self):
        response = self._staff_client().get(reverse('update_donation_status', args=[self.donation.pk]))

        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
        self.donation.refresh_from_db()
        self.assertEqual(self.donation.status, Donation.STATUS_PENDING)

    def test_regular_user_cannot_update_donation_status(self):
        client = Client()
        client.force_login(self.user)

        response = client.post(
            reverse('update_donation_status', args=[self.donation.pk]),
            {'status': Donation.STATUS_ACCEPTED},
        )

        self.assertEqual(response.status_code, 302)
        self.donation.refresh_from_db()
        self.assertEqual(self.donation.status, Donation.STATUS_PENDING)

    def test_invalid_donation_status_is_rejected(self):
        response = self._staff_client().post(
            reverse('update_donation_status', args=[self.donation.pk]),
            {'status': 'not-a-valid-status'},
            follow=True,
        )

        self.assertEqual(response.status_code, 200)
        self.donation.refresh_from_db()
        self.assertEqual(self.donation.status, Donation.STATUS_PENDING)
        self.assertContains(response, 'الحالة غير صالحة')

    def test_staff_can_open_volunteer_applications_page(self):
        response = self._staff_client().get(reverse('volunteer_applications_list'))

        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'STATUS_TEST_OPPORTUNITY')
        self.assertContains(response, 'status-volunteer')
        self.assertContains(response, reverse('update_volunteer_application_status', args=[self.application.pk]))

    def test_staff_can_update_volunteer_application_status_to_accepted_with_post(self):
        response = self._staff_client().post(
            reverse('update_volunteer_application_status', args=[self.application.pk]),
            {'status': VolunteerApplication.STATUS_ACCEPTED},
            follow=True,
        )

        self.assertEqual(response.status_code, 200)
        self.application.refresh_from_db()
        self.assertEqual(self.application.status, VolunteerApplication.STATUS_ACCEPTED)
        self.assertContains(response, 'تم تحديث حالة طلب التطوع إلى مقبول.')

    def test_get_cannot_update_volunteer_application_status(self):
        response = self._staff_client().get(
            reverse('update_volunteer_application_status', args=[self.application.pk])
        )

        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
        self.application.refresh_from_db()
        self.assertEqual(self.application.status, VolunteerApplication.STATUS_PENDING)

    def test_regular_user_cannot_update_volunteer_application_status(self):
        client = Client()
        client.force_login(self.user)

        response = client.post(
            reverse('update_volunteer_application_status', args=[self.application.pk]),
            {'status': VolunteerApplication.STATUS_ACCEPTED},
        )

        self.assertEqual(response.status_code, 302)
        self.application.refresh_from_db()
        self.assertEqual(self.application.status, VolunteerApplication.STATUS_PENDING)

    def test_api_returns_updated_donation_status_after_management_update(self):
        self._staff_client().post(
            reverse('update_donation_status', args=[self.donation.pk]),
            {'status': Donation.STATUS_ACCEPTED},
        )
        api_client = APIClient()
        api_client.force_authenticate(user=self.donor)

        response = api_client.get('/api/donations/my-donations/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.json()[0]['status'], Donation.STATUS_ACCEPTED)

    def test_api_returns_updated_volunteer_application_status_after_management_update(self):
        self._staff_client().post(
            reverse('update_volunteer_application_status', args=[self.application.pk]),
            {'status': VolunteerApplication.STATUS_ACCEPTED},
        )
        api_client = APIClient()
        api_client.force_authenticate(user=self.volunteer)

        response = api_client.get('/api/volunteer-applications/my-applications/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.json()[0]['status'], VolunteerApplication.STATUS_ACCEPTED)


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
