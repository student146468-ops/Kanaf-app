import 'package:flutter/material.dart';

import '../models/donation_model.dart';
import '../models/need_model.dart';
import '../models/orphan_model.dart';
import '../models/volunteer_model.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  List<OrphanModel> _orphans = [];
  OrphanModel? _selectedOrphan;
  List<DonationModel> _donations = [];
  List<DonationModel> _myDonations = [];
  List<VolunteerModel> _volunteers = [];
  List<NeedModel> _needs = [];
  List<Map<String, dynamic>> _volunteerOpportunities = [];
  List<Map<String, dynamic>> _volunteerApplications = [];
  List<Map<String, dynamic>> _careHomes = [];
  NeedModel? _selectedNeed;
  Map<String, dynamic> _currentUser = {};
  Map<String, dynamic> _dashboardStats = {};
  Map<String, dynamic> _reports = {};
  Map<String, dynamic> _careHomeProfile = {};
  List<Map<String, dynamic>> _visitHours = [];
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _volunteerRequests = [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  List<OrphanModel> get orphans => _orphans;
  OrphanModel? get selectedOrphan => _selectedOrphan;
  List<DonationModel> get donations => _donations;
  List<DonationModel> get myDonations => _myDonations;
  List<VolunteerModel> get volunteers => _volunteers;
  List<NeedModel> get needs => _needs;
  List<Map<String, dynamic>> get volunteerOpportunities =>
      _volunteerOpportunities;
  List<Map<String, dynamic>> get volunteerApplications =>
      _volunteerApplications;
  List<Map<String, dynamic>> get careHomes => _careHomes;
  NeedModel? get selectedNeed => _selectedNeed;
  Map<String, dynamic> get currentUser => _currentUser;
  Map<String, dynamic> get dashboardStats => _dashboardStats;
  Map<String, dynamic> get reports => _reports;
  Map<String, dynamic> get careHomeProfile => _careHomeProfile;
  List<Map<String, dynamic>> get visitHours => _visitHours;
  List<Map<String, dynamic>> get notifications => _notifications;
  List<Map<String, dynamic>> get volunteerRequests => _volunteerRequests;

  Future<void> fetchOrphans() async {
    await _load(() async {
      final data = await _apiService.getOrphans();
      _orphans = data
          .map((item) =>
              OrphanModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    });
  }

  Future<void> fetchCurrentUser({bool notifyLoading = true}) async {
    await _load(() async {
      _currentUser = await _apiService.getMe();
    }, notifyLoading: notifyLoading);
  }

  Future<void> fetchOrphanDetails(int id) async {
    await _load(() async {
      _selectedOrphan =
          OrphanModel.fromJson(await _apiService.getOrphanDetails(id));
    });
  }

  Future<void> addOrphan(Map<String, dynamic> orphanData) async {
    await _save(() async {
      _orphans
          .add(OrphanModel.fromJson(await _apiService.addOrphan(orphanData)));
    });
  }

  Future<void> fetchDonations() async {
    await _load(() async {
      final data = await _apiService.getDonations();
      _donations = data
          .map((item) =>
              DonationModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    });
  }

  Future<void> createDonation(Map<String, dynamic> donationData) async {
    await _save(() async {
      _donations.add(DonationModel.fromJson(
          await _apiService.createDonation(donationData)));
    });
  }

  Future<bool> submitDonation(Map<String, dynamic> donationData) {
    return _save(() async {
      final created = DonationModel.fromJson(
          await _apiService.createDonation(donationData));
      _donations.insert(0, created);
      _myDonations.insert(0, created);
    });
  }

  Future<void> fetchMyDonations() async {
    await _load(() async {
      final data = await _apiService.getMyDonations();
      _myDonations = data
          .map((item) =>
              DonationModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    });
  }

  Future<bool> confirmDonationReceived(int id) async {
    return _save(() async {
      final updated =
          DonationModel.fromJson(await _apiService.confirmDonationReceived(id));
      _replaceDonation(updated);
      await fetchNeeds(notifyLoading: false);
      await fetchDashboardStats(notifyLoading: false);
    });
  }

  Future<void> fetchVolunteers() async {
    await _load(() async {
      final data = await _apiService.getVolunteers();
      _volunteers = data
          .map((item) =>
              VolunteerModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    });
  }

  Future<void> applyAsVolunteer(Map<String, dynamic> volunteerData) async {
    await _save(() async {
      _volunteers.add(VolunteerModel.fromJson(
          await _apiService.applyAsVolunteer(volunteerData)));
    });
  }

  Future<void> fetchDashboardStats({bool notifyLoading = true}) async {
    await _load(() async {
      _dashboardStats = await _apiService.getDashboardStats();
      final careHome = _dashboardStats['care_home'];
      if (careHome is Map) {
        _careHomeProfile = Map<String, dynamic>.from(careHome);
      }
    }, notifyLoading: notifyLoading);
  }

  Future<void> fetchReports() async {
    await _load(() async {
      _reports = await _apiService.getReports();
    });
  }

  Future<void> fetchNeeds({bool notifyLoading = true}) async {
    await _load(() async {
      final data = await _apiService.getNeeds();
      _needs = data
          .map((item) =>
              NeedModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }, notifyLoading: notifyLoading);
  }

  Future<void> fetchVolunteerOpportunities({bool notifyLoading = true}) async {
    await _load(() async {
      final data = await _apiService.getVolunteerOpportunities();
      _volunteerOpportunities =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }, notifyLoading: notifyLoading);
  }

  Future<bool> applyToVolunteerOpportunity(
      int opportunityId, Map<String, dynamic> data) {
    return _save(() async {
      await _apiService.applyToVolunteerOpportunity(opportunityId, data);
      await fetchVolunteerOpportunities(notifyLoading: false);
    });
  }

  Future<void> fetchVolunteerApplications({bool notifyLoading = true}) async {
    await _load(() async {
      final data = await _apiService.getVolunteerApplications();
      _volunteerApplications =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }, notifyLoading: notifyLoading);
  }

  Future<void> fetchNeedDetails(int id) async {
    await _load(() async {
      _selectedNeed = NeedModel.fromJson(await _apiService.getNeedDetails(id));
    });
  }

  Future<bool> createNeed(Map<String, dynamic> data) async {
    return _save(() async {
      final created = NeedModel.fromJson(await _apiService.createNeed(data));
      _needs.insert(0, created);
      await fetchDashboardStats(notifyLoading: false);
    });
  }

  Future<bool> updateNeed(int id, Map<String, dynamic> data) async {
    return _save(() async {
      final updated =
          NeedModel.fromJson(await _apiService.updateNeed(id, data));
      _replaceNeed(updated);
      _selectedNeed = updated;
      await fetchDashboardStats(notifyLoading: false);
    });
  }

  Future<bool> archiveNeed(int id) async {
    return _save(() async {
      await _apiService.archiveNeed(id);
      _needs.removeWhere((need) => need.id == id);
      await fetchDashboardStats(notifyLoading: false);
    });
  }

  Future<void> fetchCareHomeProfile() async {
    await _load(() async {
      _careHomeProfile = await _apiService.getCareHomeProfile();
    });
  }

  Future<void> fetchCareHomes({bool notifyLoading = true}) async {
    await _load(() async {
      final data = await _apiService.getCareHomes();
      _careHomes =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }, notifyLoading: notifyLoading);
  }

  Future<bool> updateCareHomeProfile(Map<String, dynamic> data) async {
    return _save(() async {
      _careHomeProfile = await _apiService.updateCareHomeProfile(data);
      await fetchDashboardStats(notifyLoading: false);
    });
  }

  Future<void> fetchVisitHours() async {
    await _load(() async {
      final data = await _apiService.getVisitHours();
      _visitHours =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    });
  }

  Future<bool> createVisitHour(Map<String, dynamic> data) {
    return _save(() async {
      final created = await _apiService.createVisitHour(data);
      _visitHours.add(created);
    });
  }

  Future<bool> updateVisitHour(int id, Map<String, dynamic> data) {
    return _save(() async {
      final updated = await _apiService.updateVisitHour(id, data);
      final index = _visitHours.indexWhere((item) => item['id'] == id);
      if (index == -1) {
        _visitHours.add(updated);
      } else {
        _visitHours[index] = updated;
      }
    });
  }

  Future<bool> deleteVisitHour(int id) {
    return _save(() async {
      await _apiService.deleteVisitHour(id);
      _visitHours.removeWhere((item) => item['id'] == id);
    });
  }

  Future<void> fetchNotifications() async {
    await _load(() async {
      final data = await _apiService.getNotifications();
      _notifications =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    });
  }

  Future<bool> markNotificationRead(int id) {
    return _save(() async {
      await _apiService.markNotificationRead(id);
      final index = _notifications.indexWhere((item) => item['id'] == id);
      if (index != -1) _notifications[index]['is_read'] = true;
    });
  }

  Future<bool> markAllNotificationsRead() {
    return _save(() async {
      await _apiService.markAllNotificationsRead();
      for (final notification in _notifications) {
        notification['is_read'] = true;
      }
    });
  }

  Future<void> fetchVolunteerRequests() async {
    await _load(() async {
      final data = await _apiService.getVolunteerRequests();
      _volunteerRequests =
          data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    });
  }

  Future<bool> acceptVolunteerRequest(int id) {
    return _save(() async {
      await _apiService.acceptVolunteerRequest(id);
      await fetchVolunteerRequests();
    });
  }

  Future<bool> rejectVolunteerRequest(int id) {
    return _save(() async {
      await _apiService.rejectVolunteerRequest(id);
      await fetchVolunteerRequests();
    });
  }

  Future<bool> rateVolunteerRequest(int id, Map<String, dynamic> data) {
    return _save(() async {
      await _apiService.rateVolunteerRequest(id, data);
      await fetchVolunteerRequests();
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearAll() {
    _orphans = [];
    _donations = [];
    _myDonations = [];
    _volunteers = [];
    _needs = [];
    _volunteerOpportunities = [];
    _volunteerApplications = [];
    _careHomes = [];
    _currentUser = {};
    _dashboardStats = {};
    _reports = {};
    _careHomeProfile = {};
    _visitHours = [];
    _notifications = [];
    _volunteerRequests = [];
    _selectedOrphan = null;
    _selectedNeed = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _load(Future<void> Function() loader,
      {bool notifyLoading = true}) async {
    if (notifyLoading) _setLoading(true);
    try {
      await loader();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
    } finally {
      if (notifyLoading) _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> _save(Future<void> Function() saver) async {
    if (_isSaving) return false;
    _isSaving = true;
    notifyListeners();
    try {
      await saver();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _replaceNeed(NeedModel updated) {
    final index = _needs.indexWhere((need) => need.id == updated.id);
    if (index == -1) {
      _needs.insert(0, updated);
    } else {
      _needs[index] = updated;
    }
  }

  void _replaceDonation(DonationModel updated) {
    final index =
        _donations.indexWhere((donation) => donation.id == updated.id);
    if (index == -1) {
      _donations.insert(0, updated);
    } else {
      _donations[index] = updated;
    }
  }
}
