import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_config.dart';
import 'api_service.dart' as standard_api;

/// خدمة الـ API المحسّنة - نقطة الاتصال الموحدة بين التطبيق والمنظومة
class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  // عنوان المنظومة الأساسي (يمكن تغييره حسب البيئة)
  static String get baseUrl => ApiConfig.baseUrl;

  // متغير لتخزين المستخدم الحالي
  UserModel? _currentUser;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    debugPrint(
      'Kanaf professional API baseUrl=$baseUrl '
      'connectTimeout=30s receiveTimeout=30s',
    );
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    // إضافة Interceptor للتعامل مع الأخطاء والتوثيق
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // إضافة التوكن إذا كان موجوداً
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (error, handler) {
          // معالجة الأخطاء
          debugPrint('❌ خطأ في الاتصال: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // ============ عمليات المصادقة (Authentication) - بدون OTP ============

  /// تسجيل دخول المستخدم (بدون OTP)
  Future<Map<String, dynamic>> login(String email, String password) async {
    const path = '/auth/login/';
    final requestData = {'email': email, 'password': password};
    _logAuthRequest('POST', path, requestData);
    try {
      final response = await _dio.post(
        path,
        data: requestData,
      );
      _logAuthResponse('professional login', response);

      if (response.statusCode == 200) {
        final responseData = _extractMap(response.data);
        await _saveAuthSession(responseData);
        return responseData;
      }
      throw const standard_api.ApiServiceException(
        'تعذر إكمال تسجيل الدخول حالياً. حاول مرة أخرى.',
      );
    } on DioException catch (e) {
      debugPrint('Professional login API error: ${_developerErrorSummary(e)}');
      throw standard_api.ApiServiceException(
        standard_api.ApiService.friendlyMessageForDioException(
          e,
          isLogin: true,
          authEndpoint: true,
        ),
      );
    } on standard_api.ApiServiceException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Professional login response handling error: $e\n$stackTrace');
      throw const standard_api.ApiServiceException(
        'تعذر إكمال تسجيل الدخول حالياً. حاول مرة أخرى.',
      );
    }
  }

  /// تسجيل مستخدم جديد (بدون OTP)
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    const path = '/auth/register/';
    _logAuthRequest('POST', path, userData);
    try {
      final response = await _dio.post(
        path,
        data: userData,
      );
      _logAuthResponse('professional register', response);

      if (response.statusCode == 201) {
        final responseData = _extractMap(response.data);
        await _saveAuthSession(responseData);
        return responseData;
      }
      throw const standard_api.ApiServiceException(
        'تعذر إكمال إنشاء الحساب حالياً. حاول مرة أخرى.',
      );
    } on DioException catch (e) {
      debugPrint(
          'Professional register API error: ${_developerErrorSummary(e)}');
      throw standard_api.ApiServiceException(
        standard_api.ApiService.friendlyMessageForDioException(
          e,
          isRegister: true,
          authEndpoint: true,
        ),
      );
    } on standard_api.ApiServiceException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint(
        'Professional register response handling error: $e\n$stackTrace',
      );
      throw const standard_api.ApiServiceException(
        'تعذر إكمال إنشاء الحساب حالياً. حاول مرة أخرى.',
      );
    }
  }

  static void _logAuthRequest(
    String method,
    String path,
    Map<String, dynamic> data,
  ) {
    debugPrint(
      'Kanaf professional API request: method=$method url=$baseUrl$path '
      'body=${_safeLogData(data)}',
    );
  }

  static void _logAuthResponse(String operation, Response<dynamic> response) {
    debugPrint(
      'Kanaf $operation response: url=${response.requestOptions.uri}, '
      'status=${response.statusCode}, body=${_safeLogData(response.data)}',
    );
  }

  static String _developerErrorSummary(DioException e) {
    return 'url=${e.requestOptions.uri}, method=${e.requestOptions.method}, '
        'type=${e.type}, status=${e.response?.statusCode}, '
        'message=${e.message}, response=${_safeLogData(e.response?.data)}, '
        'request=${_safeLogData(e.requestOptions.data)}';
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

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout/');
      await _clearToken();
      await _clearUser();
      _currentUser = null;
    } on DioException catch (e) {
      debugPrint('خطأ في تسجيل الخروج: ${e.message}');
    }
  }

  /// التحقق من حالة المصادقة
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }

  /// الحصول على المستخدم الحالي
  UserModel? get currentUser => _currentUser;

  /// تحميل المستخدم الحالي من التخزين المحلي
  Future<UserModel?> loadCurrentUser() async {
    _currentUser = await _getUser();
    return _currentUser;
  }

  // ============ عمليات الأيتام (Orphans) ============

  /// الحصول على قائمة الأيتام
  Future<List<dynamic>> getOrphans() async {
    try {
      final response = await _dio.get('/orphans/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب الأيتام: ${e.message}');
    }
  }

  /// الحصول على تفاصيل يتيم محدد
  Future<Map<String, dynamic>> getOrphanDetails(int id) async {
    try {
      final response = await _dio.get('/orphans/$id/');
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في جلب البيانات: ${e.message}');
    }
  }

  /// إضافة يتيم جديد (للمسؤولين فقط)
  Future<Map<String, dynamic>> addOrphan(
      Map<String, dynamic> orphanData) async {
    try {
      final response = await _dio.post('/orphans/', data: orphanData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في إضافة اليتيم: ${e.message}');
    }
  }

  /// تحديث بيانات يتيم
  Future<Map<String, dynamic>> updateOrphan(
      int id, Map<String, dynamic> orphanData) async {
    try {
      final response = await _dio.put('/orphans/$id/', data: orphanData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في تحديث البيانات: ${e.message}');
    }
  }

  // ============ عمليات التبرعات (Donations) ============

  /// الحصول على قائمة التبرعات
  Future<List<dynamic>> getDonations() async {
    try {
      final response = await _dio.get('/donations/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب التبرعات: ${e.message}');
    }
  }

  /// إنشاء تبرع جديد
  Future<Map<String, dynamic>> createDonation(
      Map<String, dynamic> donationData) async {
    try {
      final response = await _dio.post('/donations/', data: donationData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في إنشاء التبرع: ${e.message}');
    }
  }

  /// الحصول على سجل التبرعات الخاص بي
  Future<List<dynamic>> getMyDonations() async {
    try {
      final response = await _dio.get('/donations/my-donations/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب التبرعات: ${e.message}');
    }
  }

  // ============ عمليات المتطوعين (Volunteers) ============

  /// الحصول على قائمة المتطوعين
  Future<List<dynamic>> getVolunteers() async {
    try {
      final response = await _dio.get('/volunteers/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب المتطوعين: ${e.message}');
    }
  }

  /// التقديم للتطوع
  Future<Map<String, dynamic>> applyAsVolunteer(
      Map<String, dynamic> volunteerData) async {
    try {
      final response =
          await _dio.post('/volunteers/apply/', data: volunteerData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في التقديم: ${e.message}');
    }
  }

  /// الحصول على فرص التطوع المتاحة
  Future<List<dynamic>> getVolunteerOpportunities() async {
    try {
      final response = await _dio.get('/volunteer-opportunities/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب الفرص: ${e.message}');
    }
  }

  // ============ عمليات الكفلاء (Sponsors) ============

  /// الحصول على قائمة الكفلاء
  Future<List<dynamic>> getSponsors() async {
    try {
      final response = await _dio.get('/sponsors/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب الكفلاء: ${e.message}');
    }
  }

  /// إضافة كفيل جديد
  Future<Map<String, dynamic>> addSponsor(
      Map<String, dynamic> sponsorData) async {
    try {
      final response = await _dio.post('/sponsors/', data: sponsorData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في إضافة الكفيل: ${e.message}');
    }
  }

  // ============ عمليات المخزن (Inventory) ============

  /// الحصول على قائمة المخزن
  Future<List<dynamic>> getInventory() async {
    try {
      final response = await _dio.get('/inventory/');
      return response.data is List ? response.data : [];
    } on DioException catch (e) {
      throw Exception('خطأ في جلب المخزن: ${e.message}');
    }
  }

  /// إضافة صنف للمخزن
  Future<Map<String, dynamic>> addInventoryItem(
      Map<String, dynamic> itemData) async {
    try {
      final response = await _dio.post('/inventory/', data: itemData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في إضافة الصنف: ${e.message}');
    }
  }

  // ============ عمليات الإحصائيات (Statistics) ============

  /// الحصول على إحصائيات لوحة التحكم
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get('/stats/dashboard/');
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في جلب الإحصائيات: ${e.message}');
    }
  }

  /// الحصول على التقارير
  Future<Map<String, dynamic>> getReports() async {
    try {
      final response = await _dio.get('/reports/');
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في جلب التقارير: ${e.message}');
    }
  }

  // ============ عمليات التخزين المحلي (Local Storage) ============

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const standard_api.ApiServiceException(
      'تعذر قراءة استجابة الخادم. حاول مرة أخرى.',
    );
  }

  Future<void> _saveAuthSession(Map<String, dynamic> data) async {
    final token = data['access'] ?? data['access_token'] ?? data['token'];
    if (token == null || token.toString().isEmpty) {
      throw const standard_api.ApiServiceException(
        'تعذر إنشاء جلسة آمنة. حاول تسجيل الدخول مرة أخرى.',
      );
    }

    await _saveToken(token.toString());
    final userData = _extractMap(data['user']);
    _currentUser = UserModel.fromJson(userData);
    await _saveUser(_currentUser!);

    final role = _currentUser!.role.trim();
    if (role.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));
  }

  Future<UserModel?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      try {
        return UserModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(userJson) as Map),
        );
      } catch (e) {
        debugPrint('خطأ في تحميل بيانات المستخدم: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}
