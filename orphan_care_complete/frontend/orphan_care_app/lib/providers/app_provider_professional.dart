import 'package:flutter/material.dart';
import '../models/orphan_model.dart';
import '../models/donation_model.dart';
import '../models/volunteer_model.dart';
import '../models/user_model.dart';
import '../services/api_service_professional.dart';

/// Provider لإدارة حالة التطبيق الشاملة - نسخة احترافية
class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ============ حالات التحميل والأخطاء ============
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // ============ حالة المصادقة ============
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  // ============ بيانات الأيتام ============
  List<OrphanModel> _orphans = [];
  OrphanModel? _selectedOrphan;

  // ============ بيانات التبرعات ============
  List<DonationModel> _donations = [];
  List<DonationModel> _myDonations = [];

  // ============ بيانات المتطوعين ============
  List<VolunteerModel> _volunteers = [];

  // ============ الإحصائيات ============
  Map<String, dynamic> _dashboardStats = {};

  // ============ Getters ============

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  List<OrphanModel> get orphans => _orphans;
  OrphanModel? get selectedOrphan => _selectedOrphan;

  List<DonationModel> get donations => _donations;
  List<DonationModel> get myDonations => _myDonations;

  List<VolunteerModel> get volunteers => _volunteers;

  Map<String, dynamic> get dashboardStats => _dashboardStats;

  // ============ عمليات المصادقة ============

  /// تسجيل الدخول (بدون OTP)
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final data = await _apiService.login(email, password);
      _currentUser = UserModel.fromJson(data['user'] ?? {});
      _isAuthenticated = true;
      _successMessage = 'تم تسجيل الدخول بنجاح';
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      debugPrint('❌ خطأ في تسجيل الدخول: $e');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// تسجيل مستخدم جديد (بدون OTP)
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    try {
      final data = await _apiService.register(userData);
      _currentUser = UserModel.fromJson(data['user'] ?? {});
      _isAuthenticated = true;
      _successMessage = 'تم التسجيل بنجاح';
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      debugPrint('❌ خطأ في التسجيل: $e');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.logout();
      _currentUser = null;
      _isAuthenticated = false;
      clearAll();
      _successMessage = 'تم تسجيل الخروج بنجاح';
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في تسجيل الخروج: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// التحقق من حالة المصادقة
  Future<void> checkAuthentication() async {
    try {
      final isAuth = await _apiService.isAuthenticated();
      if (isAuth) {
        _currentUser = await _apiService.loadCurrentUser();
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  // ============ عمليات الأيتام ============

  /// جلب قائمة الأيتام
  Future<void> fetchOrphans() async {
    _setLoading(true);
    try {
      final data = await _apiService.getOrphans();
      _orphans = data
          .map((item) => OrphanModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب الأيتام: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// جلب تفاصيل يتيم محدد
  Future<void> fetchOrphanDetails(int id) async {
    _setLoading(true);
    try {
      final data = await _apiService.getOrphanDetails(id);
      _selectedOrphan = OrphanModel.fromJson(data);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب البيانات: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// إضافة يتيم جديد
  Future<bool> addOrphan(Map<String, dynamic> orphanData) async {
    _setLoading(true);
    try {
      final data = await _apiService.addOrphan(orphanData);
      _orphans.add(OrphanModel.fromJson(data));
      _successMessage = 'تم إضافة اليتيم بنجاح';
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في إضافة اليتيم: $e');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============ عمليات التبرعات ============

  /// جلب قائمة التبرعات
  Future<void> fetchDonations() async {
    _setLoading(true);
    try {
      final data = await _apiService.getDonations();
      _donations = data
          .map((item) => DonationModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب التبرعات: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// إنشاء تبرع جديد
  Future<bool> createDonation(Map<String, dynamic> donationData) async {
    _setLoading(true);
    try {
      final data = await _apiService.createDonation(donationData);
      _donations.add(DonationModel.fromJson(data));
      _successMessage = 'تم إنشاء التبرع بنجاح';
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في إنشاء التبرع: $e');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// جلب التبرعات الخاصة بي
  Future<void> fetchMyDonations() async {
    _setLoading(true);
    try {
      final data = await _apiService.getMyDonations();
      _myDonations = data
          .map((item) => DonationModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب التبرعات: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ============ عمليات المتطوعين ============

  /// جلب قائمة المتطوعين
  Future<void> fetchVolunteers() async {
    _setLoading(true);
    try {
      final data = await _apiService.getVolunteers();
      _volunteers = data
          .map((item) => VolunteerModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب المتطوعين: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// التقديم للتطوع
  Future<bool> applyAsVolunteer(Map<String, dynamic> volunteerData) async {
    _setLoading(true);
    try {
      final data = await _apiService.applyAsVolunteer(volunteerData);
      _volunteers.add(VolunteerModel.fromJson(data));
      _successMessage = 'تم التقديم بنجاح';
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في التقديم: $e');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============ عمليات الإحصائيات ============

  /// جلب إحصائيات لوحة التحكم
  Future<void> fetchDashboardStats() async {
    _setLoading(true);
    try {
      _dashboardStats = await _apiService.getDashboardStats();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب الإحصائيات: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ============ عمليات مساعدة ============

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  void clearAll() {
    _orphans.clear();
    _donations.clear();
    _myDonations.clear();
    _volunteers.clear();
    _dashboardStats.clear();
    _selectedOrphan = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
