// lib/features/feat_services/services/services_provider.dart

import 'package:flutter/foundation.dart';
import '../models/service_model.dart';
import '../models/equipment_model.dart';
import '../models/service_request_model.dart';
import 'repair_service_client.dart';
import '../../../core/errors/pocketbase_error_handler.dart';

class ServicesProvider with ChangeNotifier {
  final RepairServiceClient _client = RepairServiceClient();

  List<ServiceModel> _services = [];
  List<EquipmentModel> _userEquipments = [];
  List<ServiceRequestModel> _userRequests = [];

  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  List<ServiceModel> get services => _services;

  List<EquipmentModel> get userEquipments => _userEquipments;

  List<ServiceRequestModel> get userRequests => _userRequests;

  bool get isLoading => _isLoading;

  bool get isActionLoading => _isActionLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _client.getAvailableServices();
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserEquipments(String userId) async {
    try {
      _userEquipments = await _client.getUserEquipments(userId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user equipments: $e');
    }
  }

  Future<bool> addNewEquipment(Map<String, dynamic> data) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _client.addEquipment(data);
      final userId = data['user'];
      if (userId != null) {
        await fetchUserEquipments(userId);
      }
      return true;
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e);
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitRepairRequest({
    required String userId,
    required String userTier,
    required String serviceId,
    required String equipmentId,
    required String issueDescription,
  }) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _client.createRepairRequest(
        userId: userId,
        userTier: userTier,
        serviceId: serviceId,
        equipmentId: equipmentId,
        issueDescription: issueDescription,
      );
      await fetchUserRequests(userId);
      return true;
    } catch (e) {
      final errStr = e.toString();
      _errorMessage = errStr.contains('Exception:')
          ? errStr.replaceAll('Exception: ', '').trim()
          : getFriendlyErrorMessage(e);
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserRequests(String userId) async {
    try {
      _userRequests = await _client.getUserRequests(userId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user requests: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
