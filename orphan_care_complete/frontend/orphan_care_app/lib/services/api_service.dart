import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة الـ API - نقطة الاتصال الموحدة بين التطبيق والمنظومة
class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  
  // عنوان المنظومة الأساسي (يمكن تغييره حسب البيئة)
  static const String baseUrl = 'http://localhost:8000/api';
  
  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
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
          print('❌ خطأ في الاتصال: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // ============ عمليات المصادقة (Authentication) ============

  /// تسجيل دخول المستخدم
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login/',
        data: {'email': email, 'password': password},
      );
      
      if (response.statusCode == 200) {
        // حفظ التوكن
        await _saveToken(response.data['token']);
        return response.data;
      }
      throw Exception('فشل تسجيل الدخول');
    } on DioException catch (e) {
      throw Exception('خطأ في الاتصال: ${e.message}');
    }
  }

  /// تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        '/auth/register/',
        data: userData,
      );
      
      if (response.statusCode == 201) {
        await _saveToken(response.data['token']);
        return response.data;
      }
      throw Exception('فشل التسجيل');
    } on DioException catch (e) {
      throw Exception('خطأ في الاتصال: ${e.message}');
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout/');
      await _clearToken();
    } on DioException catch (e) {
      print('خطأ في تسجيل الخروج: ${e.message}');
    }
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
  Future<Map<String, dynamic>> addOrphan(Map<String, dynamic> orphanData) async {
    try {
      final response = await _dio.post('/orphans/', data: orphanData);
      return response.data;
    } on DioException catch (e) {
      throw Exception('خطأ في إضافة اليتيم: ${e.message}');
    }
  }

  /// تحديث بيانات يتيم
  Future<Map<String, dynamic>> updateOrphan(int id, Map<String, dynamic> orphanData) async {
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
  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> donationData) async {
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
  Future<Map<String, dynamic>> applyAsVolunteer(Map<String, dynamic> volunteerData) async {
    try {
      final response = await _dio.post('/volunteers/apply/', data: volunteerData);
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
  Future<Map<String, dynamic>> addSponsor(Map<String, dynamic> sponsorData) async {
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
  Future<Map<String, dynamic>> addInventoryItem(Map<String, dynamic> itemData) async {
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
  }

  /// التحقق من حالة المصادقة
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }
}
