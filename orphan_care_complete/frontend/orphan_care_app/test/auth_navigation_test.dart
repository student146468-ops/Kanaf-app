import 'package:flutter_test/flutter_test.dart';
import 'package:kanaf/utils/auth_navigation.dart';

void main() {
  group('AuthNavigation', () {
    test('routes known API roles to their own home screens', () {
      expect(
        AuthNavigation.homeRouteForRole('care_home'),
        '/care_home_dashboard',
      );
      expect(AuthNavigation.homeRouteForRole('donor'), '/supporter_home');
      expect(AuthNavigation.homeRouteForRole('volunteer'), '/volunteer_home');
    });

    test('normalizes supported role aliases without defaulting to donor', () {
      expect(
          AuthNavigation.homeRouteForRole('carehome'), '/care_home_dashboard');
      expect(
          AuthNavigation.homeRouteForRole('orphanage'), '/care_home_dashboard');
      expect(AuthNavigation.homeRouteForRole('supporter'), '/supporter_home');
      expect(AuthNavigation.homeRouteForRole('admin'), isNull);
      expect(AuthNavigation.homeRouteForRole(null), isNull);
      expect(AuthNavigation.homeRouteForRole(''), isNull);
    });

    test('extracts role from auth API user payload', () {
      expect(
        AuthNavigation.roleFromAuthResponse({
          'access': 'token',
          'user': {'role': 'care_home'},
        }),
        'care_home',
      );
      expect(
        AuthNavigation.roleFromAuthResponse({
          'access': 'token',
          'user': {
            'profile': {'role': 'volunteer'}
          },
        }),
        'volunteer',
      );
      expect(
        AuthNavigation.roleFromAuthResponse({'access': 'token'}),
        isNull,
      );
    });
  });
}
