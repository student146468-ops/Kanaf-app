import 'package:flutter/material.dart';

class AuthNavigation {
  static const String donorRole = 'donor';
  static const String volunteerRole = 'volunteer';
  static const String careHomeRole = 'care_home';

  static String? normalizeRole(String? role) {
    final value = role?.trim().toLowerCase().replaceAll('-', '_');
    if (value == null || value.isEmpty) return null;

    switch (value) {
      case donorRole:
      case 'supporter':
        return donorRole;
      case volunteerRole:
        return volunteerRole;
      case careHomeRole:
      case 'carehome':
      case 'orphanage':
        return careHomeRole;
      default:
        return null;
    }
  }

  static String? roleFromAuthResponse(Map<String, dynamic> response) {
    final candidates = <dynamic>[
      response['role'],
      response['user_role'],
      response['account_type'],
      response['userType'],
    ];

    final user = response['user'];
    if (user is Map) {
      candidates.addAll([
        user['role'],
        user['user_role'],
        user['account_type'],
        user['userType'],
      ]);

      final profile = user['profile'];
      if (profile is Map) {
        candidates.addAll([
          profile['role'],
          profile['user_role'],
          profile['account_type'],
        ]);
      }
    }

    final data = response['data'];
    if (data is Map) {
      candidates.addAll([
        data['role'],
        data['user_role'],
        data['account_type'],
      ]);

      final dataUser = data['user'];
      if (dataUser is Map) {
        candidates.addAll([
          dataUser['role'],
          dataUser['user_role'],
          dataUser['account_type'],
        ]);
      }
    }

    for (final candidate in candidates) {
      final normalized = normalizeRole(candidate?.toString());
      if (normalized != null) return normalized;
    }
    return null;
  }

  static String? homeRouteForRole(String? role) {
    switch (normalizeRole(role)) {
      case careHomeRole:
        return '/care_home_dashboard';
      case donorRole:
        return '/supporter_home';
      case volunteerRole:
        return '/volunteer_home';
      default:
        return null;
    }
  }

  static void navigateByRole(
    BuildContext context,
    String? role, {
    bool showUnknownRoleMessage = true,
  }) {
    final routeName = homeRouteForRole(role);

    if (routeName == null) {
      if (showUnknownRoleMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر تحديد نوع الحساب. الرجاء اختيار نوع الحساب مرة أخرى.',
            ),
          ),
        );
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/role_selection',
        (route) => false,
      );
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }
}
