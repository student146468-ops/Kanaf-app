import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const String localWebBaseUrl = 'http://127.0.0.1:8000/api';
  static const String androidDebugBaseUrl = String.fromEnvironment(
    'ANDROID_DEBUG_API_BASE_URL',
    defaultValue: 'http://10.23.134.228:8000/api',
  );
  static const String productionBaseUrl = String.fromEnvironment(
    'PRODUCTION_API_BASE_URL',
    defaultValue: 'https://kanafapp.pythonanywhere.com/api',
  );

  static String get baseUrl => resolveBaseUrl(
        configuredBaseUrl: configuredBaseUrl,
        isWeb: kIsWeb,
        isDebug: kDebugMode,
        targetPlatform: defaultTargetPlatform,
      );

  static Uri get registerUri => Uri.parse('$baseUrl/auth/register/');

  @visibleForTesting
  static String resolveBaseUrl({
    String configuredBaseUrl = '',
    required bool isWeb,
    required bool isDebug,
    required TargetPlatform targetPlatform,
  }) {
    final explicitBaseUrl = configuredBaseUrl.trim();
    if (explicitBaseUrl.isNotEmpty) {
      return _withoutTrailingSlash(explicitBaseUrl);
    }

    if (isDebug) {
      if (isWeb) return localWebBaseUrl;
      if (targetPlatform == TargetPlatform.android) {
        return _withoutTrailingSlash(androidDebugBaseUrl);
      }
    }

    return _withoutTrailingSlash(productionBaseUrl);
  }

  static String _withoutTrailingSlash(String value) {
    return value.trim().replaceFirst(RegExp(r'/+$'), '');
  }
}
