import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanaf/services/api_config.dart';
import 'package:kanaf/services/api_service.dart';
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

  group('Auth API error messages', () {
    test('resolves API base URL by platform', () {
      expect(
        ApiConfig.resolveBaseUrl(
          configuredBaseUrl: '',
          isWeb: true,
          isDebug: true,
          targetPlatform: TargetPlatform.windows,
        ),
        'http://127.0.0.1:8000/api',
      );
      expect(
        ApiConfig.resolveBaseUrl(
          configuredBaseUrl: '',
          isWeb: false,
          isDebug: true,
          targetPlatform: TargetPlatform.android,
        ),
        'http://10.23.134.228:8000/api',
      );
      expect(
        ApiConfig.resolveBaseUrl(
          configuredBaseUrl: 'http://192.168.1.10:8000/api/',
          isWeb: false,
          isDebug: true,
          targetPlatform: TargetPlatform.android,
        ),
        'http://192.168.1.10:8000/api',
      );
    });

    test('does not expose technical details for missing login endpoint', () {
      final message = ApiService.friendlyMessageForDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login/'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login/'),
            statusCode: 404,
            data: '<html>Page not found at /api/auth/login/</html>',
          ),
        ),
        isLogin: true,
        authEndpoint: true,
      );

      expect(message, 'تعذر الوصول إلى خدمة تسجيل الدخول حالياً.');
      expect(message, isNot(contains('404')));
      expect(message, isNot(contains('html')));
    });

    test('maps invalid login credentials to a user friendly message', () {
      final message = ApiService.friendlyMessageForDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login/'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login/'),
            statusCode: 401,
            data: {'detail': 'invalid credentials'},
          ),
        ),
        isLogin: true,
        authEndpoint: true,
      );

      expect(message, 'البريد الإلكتروني أو كلمة المرور غير صحيحة.');
    });

    test('maps duplicate register email to a user friendly message', () {
      final message = ApiService.friendlyMessageForDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register/'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/register/'),
            statusCode: 400,
            data: {'detail': 'username or email already exists'},
          ),
        ),
        isRegister: true,
        authEndpoint: true,
      );

      expect(message, 'هذا البريد الإلكتروني مستخدم بالفعل.');
    });

    test('maps timeout and connection errors without DioException text', () {
      final timeoutMessage = ApiService.friendlyMessageForDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login/'),
          type: DioExceptionType.connectionTimeout,
        ),
        isLogin: true,
        authEndpoint: true,
      );
      final connectionMessage = ApiService.friendlyMessageForDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login/'),
          type: DioExceptionType.connectionError,
        ),
        isLogin: true,
        authEndpoint: true,
      );

      expect(
        timeoutMessage,
        'استغرق الاتصال وقتاً أطول من المتوقع. حاول مرة أخرى.',
      );
      expect(
        connectionMessage,
        'تعذر الاتصال بخدمة تسجيل الدخول حالياً. تأكد من تشغيل الخادم وحاول مرة أخرى.',
      );
      expect(timeoutMessage, isNot(contains('DioException')));
      expect(connectionMessage, isNot(contains('DioException')));
    });
  });
}
