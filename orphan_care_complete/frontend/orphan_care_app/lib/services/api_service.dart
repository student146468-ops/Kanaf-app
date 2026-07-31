import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth_navigation.dart';
import 'api_config.dart';

class ApiServiceException implements Exception {
  final String message;

  const ApiServiceException(this.message);

  @override
  String toString() => message;
}

const String _registerServiceUnavailableMessage =
    'تعذر الاتصال بخدمة إنشاء الحساب حالياً. تأكد من تشغيل الخادم وحاول مرة أخرى.';
const String _loginServiceUnavailableMessage =
    'تعذر الاتصال بخدمة تسجيل الدخول حالياً. تأكد من تشغيل الخادم وحاول مرة أخرى.';
const String _duplicateEmailMessage =
    'هذا البريد الإلكتروني مستخدم بالفعل.';
const String _duplicatePhoneMessage = 'رقم الهاتف مستخدم بالفعل.';
const String _duplicateAccountMessage = 'بيانات الحساب مستخدمة بالفعل.';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  static String get baseUrl1 => ApiConfig.baseUrl;

  late final Dio _dio;

  factory ApiService() => _instance;

  ApiService._internal() {
    debugPrint(
      'Kanaf API baseUrl=$baseUrl1 '
      'connectTimeout=30s receiveTimeout=30s',
    );
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl1,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.data is! FormData) {
            options.headers['Content-Type'] = 'application/json';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && await refreshAccessToken()) {
            final retry = await _dio.fetch(error.requestOptions);
            return handler.resolve(retry);
          }
          if (error.response?.statusCode == 401) {
            await _clearToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    const path = '/auth/login/';
    final requestData = {'email': email, 'password': password};
    _logAuthRequest('POST', path, requestData);
    try {
      final response = await _dio.post(
        path,
        data: requestData,
      );
      _logAuthResponse('login', response);
      final responseData = _extractMap(response.data);
      await _saveAuthSession(responseData);
      return responseData;
    } on DioException catch (e) {
      debugPrint('Login API error: ${_developerErrorSummary(e)}');
      throw ApiServiceException(
        friendlyMessageForDioException(
          e,
          isLogin: true,
          authEndpoint: true,
        ),
      );
    } on ApiServiceException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Login response handling error: $e\n$stackTrace');
      throw const ApiServiceException(
        'تعذر إكمال تسجيل الدخول حالياً. حاول مرة أخرى.',
      );
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    const path = '/auth/register/';
    _logAuthRequest('POST', path, userData);
    try {
      final response = await _dio.post(path, data: userData);
      _logAuthResponse('register', response);
      final responseData = _extractMap(response.data);
      await _saveAuthSession(responseData);
      return responseData;
    } on DioException catch (e) {
      debugPrint('Register API error: ${_developerErrorSummary(e)}');
      throw ApiServiceException(
        friendlyMessageForDioException(
          e,
          isRegister: true,
          authEndpoint: true,
        ),
      );
    } on ApiServiceException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Register response handling error: $e\n$stackTrace');
      throw const ApiServiceException(
        'تعذر إكمال إنشاء الحساب حالياً. حاول مرة أخرى.',
      );
    }
  }

  Future<void> logout() async {
    await _clearToken();
  }

  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response =
          await _dio.post('/auth/refresh/', data: {'refresh': refreshToken});
      final access = response.data['access'] ?? response.data['access_token'];
      if (access == null) return false;
      await _saveToken(access,
          refreshToken: response.data['refresh'] ?? refreshToken);
      return true;
    } on DioException {
      await _clearToken();
      return false;
    }
  }

  Future<Map<String, dynamic>> getMe() => _getMap('/auth/me/');

  Future<List<dynamic>> getOrphans() => _getList('/orphans/');
  Future<Map<String, dynamic>> getOrphanDetails(int id) =>
      _getMap('/orphans/$id/');
  Future<Map<String, dynamic>> addOrphan(Map<String, dynamic> data) =>
      _postMap('/orphans/', data);
  Future<Map<String, dynamic>> updateOrphan(
          int id, Map<String, dynamic> data) =>
      _putMap('/orphans/$id/', data);

  Future<List<dynamic>> getDonations() => _getList('/donations/');
  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> data) =>
      _postMap('/donations/', data);
  Future<List<dynamic>> getMyDonations() =>
      _getList('/donations/my-donations/');
  Future<Map<String, dynamic>> confirmDonationReceived(int id) =>
      _postMap('/donations/$id/confirm_received/', const {});

  Future<List<dynamic>> getVolunteers() => _getList('/volunteers/');
  Future<Map<String, dynamic>> applyAsVolunteer(Map<String, dynamic> data) =>
      _postMap('/volunteers/apply/', data);
  Future<List<dynamic>> getVolunteerOpportunities() =>
      _getList('/volunteer-opportunities/');
  Future<Map<String, dynamic>> applyToVolunteerOpportunity(
          int id, Map<String, dynamic> data) =>
      _postMap('/volunteer-opportunities/$id/apply/', data);
  Future<List<dynamic>> getVolunteerApplications() =>
      _getList('/volunteer-applications/');

  Future<List<dynamic>> getSponsors() => _getList('/sponsors/');
  Future<Map<String, dynamic>> addSponsor(Map<String, dynamic> data) =>
      _postMap('/sponsors/', data);

  Future<List<dynamic>> getInventory() => _getList('/inventory/');
  Future<Map<String, dynamic>> addInventoryItem(Map<String, dynamic> data) =>
      _postMap('/inventory/', data);

  Future<Map<String, dynamic>> getDashboardStats() =>
      _getMap('/stats/dashboard/');
  Future<Map<String, dynamic>> getReports() => _getMap('/reports/');

  Future<List<dynamic>> getNeeds() => _getList('/needs/');
  Future<Map<String, dynamic>> getNeedDetails(int id) => _getMap('/needs/$id/');
  Future<Map<String, dynamic>> createNeed(Map<String, dynamic> data) =>
      _postMap('/needs/', data);
  Future<Map<String, dynamic>> updateNeed(int id, Map<String, dynamic> data) =>
      _patchMap('/needs/$id/', data);
  Future<void> archiveNeed(int id) async => _dio.post('/needs/$id/archive/');

  Future<Map<String, dynamic>> getCareHomeProfile() =>
      _getMap('/care-home/profile/me/');
  Future<Map<String, dynamic>> updateCareHomeProfile(
          Map<String, dynamic> data) =>
      _patchMap('/care-home/profile/me/', data);
  Future<List<dynamic>> getCareHomes() => _getList('/care-homes/');

  Future<List<dynamic>> getVisitHours() => _getList('/visit-hours/');
  Future<Map<String, dynamic>> createVisitHour(Map<String, dynamic> data) =>
      _postMap('/visit-hours/', data);
  Future<Map<String, dynamic>> updateVisitHour(
          int id, Map<String, dynamic> data) =>
      _patchMap('/visit-hours/$id/', data);
  Future<void> deleteVisitHour(int id) async =>
      _dio.delete('/visit-hours/$id/');

  Future<List<dynamic>> getNotifications() => _getList('/notifications/');
  Future<void> markNotificationRead(int id) async =>
      _dio.post('/notifications/$id/mark_as_read/');
  Future<void> markAllNotificationsRead() async =>
      _dio.post('/notifications/mark_all_as_read/');

  Future<List<dynamic>> getVolunteerRequests() =>
      _getList('/volunteer-requests/');
  Future<Map<String, dynamic>> acceptVolunteerRequest(int id) =>
      _postMap('/volunteer-requests/$id/accept/', const {});
  Future<Map<String, dynamic>> rejectVolunteerRequest(int id) =>
      _postMap('/volunteer-requests/$id/reject/', const {});
  Future<Map<String, dynamic>> completeVolunteerRequest(
          int id, Map<String, dynamic> data) =>
      _postMap('/volunteer-requests/$id/complete/', data);
  Future<Map<String, dynamic>> rateVolunteerRequest(
          int id, Map<String, dynamic> data) =>
      _postMap('/volunteer-requests/$id/rate/', data);

  Future<List<dynamic>> _getList(String path) async {
    try {
      final response = await _dio.get(path);
      return _extractList(response.data);
    } on DioException catch (e) {
      throw ApiServiceException(_errorMessage(e, 'تعذر جلب البيانات'));
    }
  }

  Future<Map<String, dynamic>> _getMap(String path) async {
    try {
      final response = await _dio.get(path);
      return _extractMap(response.data);
    } on DioException catch (e) {
      throw ApiServiceException(_errorMessage(e, 'تعذر جلب البيانات'));
    }
  }

  Future<Map<String, dynamic>> _postMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return _extractMap(response.data);
    } on DioException catch (e) {
      throw ApiServiceException(_errorMessage(e, 'تعذر حفظ البيانات'));
    }
  }

  Future<Map<String, dynamic>> _putMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return _extractMap(response.data);
    } on DioException catch (e) {
      throw ApiServiceException(_errorMessage(e, 'تعذر تحديث البيانات'));
    }
  }

  Future<Map<String, dynamic>> _patchMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(path, data: data);
      return _extractMap(response.data);
    } on DioException catch (e) {
      throw ApiServiceException(_errorMessage(e, 'تعذر تحديث البيانات'));
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['results'] is List) return data['results'] as List;
    return [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ApiServiceException(
      'تعذر قراءة استجابة الخادم. حاول مرة أخرى.',
    );
  }

  String _errorMessage(DioException e, String fallback) {
    return friendlyMessageForDioException(e, fallback: fallback);
  }

  static String friendlyMessageForDioException(
    DioException e, {
    String fallback = 'تعذر إكمال العملية حالياً. حاول مرة أخرى.',
    bool isLogin = false,
    bool isRegister = false,
    bool authEndpoint = false,
  }) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'استغرق الاتصال وقتاً أطول من المتوقع. حاول مرة أخرى.';
    }

    if (e.response == null) {
      if (e.type == DioExceptionType.connectionError) {
        if (authEndpoint) {
          return isRegister
              ? _registerServiceUnavailableMessage
              : _loginServiceUnavailableMessage;
        }
        return 'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';
      }
      return 'تعذر الاتصال بالخادم حالياً. حاول مرة أخرى لاحقاً.';
    }

    final statusCode = e.response?.statusCode;
    if (authEndpoint && _isServerConfigurationError(e.response?.data)) {
      return isRegister
          ? _registerServiceUnavailableMessage
          : _loginServiceUnavailableMessage;
    }

    if (authEndpoint && statusCode == 404) {
      return isRegister
          ? 'تعذر الوصول إلى خدمة إنشاء الحساب حالياً.'
          : 'تعذر الوصول إلى خدمة تسجيل الدخول حالياً.';
    }

    if (authEndpoint && statusCode == 400 && _looksLikeHtml(e.response?.data)) {
      return isRegister
          ? _registerServiceUnavailableMessage
          : _loginServiceUnavailableMessage;
    }

    if (statusCode == 401 || statusCode == 403) {
      return isLogin
          ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة.'
          : 'تعذر التحقق من بيانات الحساب.';
    }

    if (statusCode == 400 || statusCode == 409) {
      final validationMessage = _validationMessage(
        e.response?.data,
        isLogin: isLogin,
        isRegister: isRegister,
      );
      if (validationMessage != null) return validationMessage;
    }

    if (statusCode == 429) {
      return 'تمت محاولات كثيرة خلال وقت قصير. حاول مرة أخرى لاحقاً.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'حدث خطأ في الخادم. حاول مرة أخرى لاحقاً.';
    }

    return fallback;
  }

  static String? _validationMessage(
    dynamic data, {
    required bool isLogin,
    required bool isRegister,
  }) {
    if (isLogin) return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

    final text = _flattenErrorText(data).toLowerCase();
    final hasConflictText = text.contains('already') ||
        text.contains('exists') ||
        text.contains('unique') ||
        text.contains('مستخدم');
    if (_fieldHasConflict(data, const ['phone_number', 'phone']) ||
        ((text.contains('phone_number') || text.contains('phone')) &&
            hasConflictText)) {
      return _duplicatePhoneMessage;
    }
    if (_fieldHasConflict(data, const ['email'])) {
      return _duplicateEmailMessage;
    }
    if (text.contains('username or email already exists') ||
        text.contains('email already exists')) {
      return _duplicateEmailMessage;
    }
    if (_fieldHasConflict(data, const ['username']) || hasConflictText) {
      return _duplicateAccountMessage;
    }
    if (text.contains('password') && text.contains('match')) {
      return 'كلمة المرور وتأكيدها غير متطابقين.';
    }
    if (text.contains('role')) {
      return 'نوع الحساب غير صحيح. الرجاء اختيار نوع الحساب مرة أخرى.';
    }
    if (text.contains('email')) {
      return 'البريد الإلكتروني غير صحيح أو مطلوب.';
    }
    if (text.contains('password')) {
      return 'كلمة المرور غير صحيحة أو غير مكتملة.';
    }
    if (text.contains('phone')) {
      return 'رقم الهاتف غير صحيح أو مطلوب.';
    }
    if (isRegister) return 'تحقق من بيانات الحساب وحاول مرة أخرى.';
    return null;
  }

  static bool _fieldHasConflict(dynamic data, List<String> fieldNames) {
    if (data is! Map) return false;

    for (final fieldName in fieldNames) {
      final value = data[fieldName];
      if (value == null) continue;

      final text = _flattenErrorText(value).toLowerCase();
      if (text.contains('already') ||
          text.contains('exists') ||
          text.contains('unique') ||
          text.contains('مستخدم')) {
        return true;
      }
    }

    return false;
  }

  static bool _isServerConfigurationError(dynamic data) {
    final text = _flattenErrorText(data).toLowerCase();
    return text.contains('disallowedhost') ||
        text.contains('invalid http_host header') ||
        text.contains('allowed_hosts');
  }

  static bool _looksLikeHtml(dynamic data) {
    return data is String && data.trimLeft().toLowerCase().startsWith('<html');
  }

  static String _flattenErrorText(dynamic data) {
    if (data is Map) {
      return data.entries
          .map((entry) => '${entry.key} ${_flattenErrorText(entry.value)}')
          .join(' ');
    }
    if (data is Iterable) {
      return data.map(_flattenErrorText).join(' ');
    }
    return data?.toString() ?? '';
  }

  static String _developerErrorSummary(DioException e) {
    final data = e.response?.data;
    final dataType = data == null ? 'none' : data.runtimeType.toString();
    return 'url=${e.requestOptions.uri}, method=${e.requestOptions.method}, '
        'type=${e.type}, status=${e.response?.statusCode}, '
        'message=${e.message}, responseType=$dataType, '
        'response=${_safeLogData(e.response?.data)}, '
        'request=${_safeLogData(e.requestOptions.data)}';
  }

  static void _logAuthRequest(
    String method,
    String path,
    Map<String, dynamic> data,
  ) {
    debugPrint(
      'Kanaf API request: method=$method url=$baseUrl1$path '
      'body=${_safeLogData(data)}',
    );
  }

  static void _logAuthResponse(String operation, Response<dynamic> response) {
    debugPrint(
      'Kanaf API $operation response: '
      'url=${response.requestOptions.uri}, '
      'status=${response.statusCode}, '
      'body=${_safeLogData(response.data)}',
    );
  }

  static String _safeLogData(dynamic data) {
    Object? sanitize(dynamic value) {
      if (value is Map) {
        return value.map((key, dynamic child) {
          final keyText = key.toString().toLowerCase();
          if (keyText.contains('password') ||
              keyText.contains('token') ||
              keyText == 'access' ||
              keyText == 'refresh') {
            return MapEntry(key, '***');
          }
          return MapEntry(key, sanitize(child));
        });
      }
      if (value is Iterable) return value.map(sanitize).toList();
      return value;
    }

    final sanitized = sanitize(data);
    final text = sanitized?.toString() ?? 'null';
    return text.length > 900 ? '${text.substring(0, 900)}...' : text;
  }

  Future<void> _saveToken(dynamic token, {dynamic refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token.toString());
    }
    if (refreshToken != null) {
      await prefs.setString('refresh_token', refreshToken.toString());
    }
  }

  Future<void> _saveAuthSession(Map<String, dynamic> data) async {
    final token = _tokenFromAuthResponse(data);
    final role = _roleFromAuthResponse(data);
    await _saveToken(token, refreshToken: _refreshTokenFromAuthResponse(data));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  String _tokenFromAuthResponse(Map<String, dynamic> data) {
    final token = data['access'] ?? data['access_token'] ?? data['token'];
    if (token == null || token.toString().isEmpty) {
      throw const ApiServiceException(
        'تعذر إنشاء جلسة آمنة. حاول تسجيل الدخول مرة أخرى.',
      );
    }
    return token.toString();
  }

  dynamic _refreshTokenFromAuthResponse(Map<String, dynamic> data) {
    return data['refresh'] ?? data['refresh_token'];
  }

  String _roleFromAuthResponse(Map<String, dynamic> data) {
    final role = AuthNavigation.roleFromAuthResponse(data);
    if (role == null) {
      throw const ApiServiceException(
        'تعذر تحديد نوع الحساب. الرجاء اختيار نوع الحساب مرة أخرى.',
      );
    }
    return role;
  }

  Future<String?> getSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthNavigation.normalizeRole(prefs.getString('user_role'));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_role');
  }

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }
}
