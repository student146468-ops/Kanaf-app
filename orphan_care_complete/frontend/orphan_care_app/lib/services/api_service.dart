import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth_navigation.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static const String baseUrl1 = 'https://kanafapp.pythonanywhere.com/api';

  late final Dio _dio;

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl1,
        connectTimeout: const Duration(seconds: 30),
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
    try {
      final response = await _dio.post(
        '/auth/login/',
        data: {'email': email, 'username': email, 'password': password},
      );
      final responseData = Map<String, dynamic>.from(response.data as Map);
      await _saveAuthSession(responseData);
      return responseData;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'فشل تسجيل الدخول'));
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/auth/register/', data: userData);
      final responseData = Map<String, dynamic>.from(response.data as Map);
      await _saveAuthSession(responseData);
      return responseData;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'فشل التسجيل'));
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
      _getList('/donations/my_donations/');
  Future<Map<String, dynamic>> confirmDonationReceived(int id) =>
      _postMap('/donations/$id/confirm_received/', const {});

  Future<List<dynamic>> getVolunteers() => _getList('/volunteers/');
  Future<Map<String, dynamic>> applyAsVolunteer(Map<String, dynamic> data) =>
      _postMap('/volunteers/apply/', data);
  Future<List<dynamic>> getVolunteerOpportunities() =>
      _getList('/volunteer-opportunities/');

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
      throw Exception(_errorMessage(e, 'تعذر جلب البيانات'));
    }
  }

  Future<Map<String, dynamic>> _getMap(String path) async {
    try {
      final response = await _dio.get(path);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'تعذر جلب البيانات'));
    }
  }

  Future<Map<String, dynamic>> _postMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'تعذر حفظ البيانات'));
    }
  }

  Future<Map<String, dynamic>> _putMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(path, data: data);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'تعذر تحديث البيانات'));
    }
  }

  Future<Map<String, dynamic>> _patchMap(
      String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(path, data: data);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'تعذر تحديث البيانات'));
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['results'] is List) return data['results'] as List;
    return [];
  }

  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data.isNotEmpty) return data.toString();
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'انتهت مهلة الاتصال';
    }
    return e.message ?? fallback;
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
    await _saveToken(
      data['access'] ?? data['access_token'] ?? data['token'],
      refreshToken: data['refresh'] ?? data['refresh_token'],
    );

    final role = AuthNavigation.roleFromAuthResponse(data);
    if (role != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
    }
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
