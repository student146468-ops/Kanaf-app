import 'package:flutter/material.dart';
import '../models/orphan_model.dart';
import '../models/donation_model.dart';
import '../models/volunteer_model.dart';
import '../services/api_service.dart';

/// Provider لإدارة حالة التطبيق الشاملة
class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ============ حالات التحميل ============
  bool _isLoading = false;
  String? _errorMessage;

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

  List<OrphanModel> get orphans => _orphans;
  OrphanModel? get selectedOrphan => _selectedOrphan;

  List<DonationModel> get donations => _donations;
  List<DonationModel> get myDonations => _myDonations;

  List<VolunteerModel> get volunteers => _volunteers;

  Map<String, dynamic> get dashboardStats => _dashboardStats;

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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب الأيتام: $e');
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب البيانات: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// إضافة يتيم جديد
  Future<void> addOrphan(Map<String, dynamic> orphanData) async {
    _setLoading(true);
    try {
      final data = await _apiService.addOrphan(orphanData);
      _orphans.add(OrphanModel.fromJson(data));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في إضافة اليتيم: $e');
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب التبرعات: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// إنشاء تبرع جديد
  Future<void> createDonation(Map<String, dynamic> donationData) async {
    _setLoading(true);
    try {
      final data = await _apiService.createDonation(donationData);
      _donations.add(DonationModel.fromJson(data));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في إنشاء التبرع: $e');
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب التبرعات: $e');
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب المتطوعين: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// التقديم للتطوع
  Future<void> applyAsVolunteer(Map<String, dynamic> volunteerData) async {
    _setLoading(true);
    try {
      final data = await _apiService.applyAsVolunteer(volunteerData);
      _volunteers.add(VolunteerModel.fromJson(data));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في التقديم: $e');
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
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ خطأ في جلب الإحصائيات: $e');
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

  void clearAll() {
    _orphans.clear();
    _donations.clear();
    _myDonations.clear();
    _volunteers.clear();
    _dashboardStats.clear();
    _selectedOrphan = null;
    _errorMessage = null;
    notifyListeners();
  }
}
