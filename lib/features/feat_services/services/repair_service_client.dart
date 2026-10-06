// lib/features/feat_services/services/repair_service_client.dart

import 'package:flutter/foundation.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';
import '../models/service_model.dart';
import '../models/equipment_model.dart';
import '../models/service_request_model.dart';

class RepairServiceClient {
  bool _hasValidTier(String? tier) {
    if (tier == null) return false;
    final lowerTier = tier.toLowerCase().trim();
    return lowerTier.isNotEmpty && lowerTier != 'free';
  }

  Future<List<ServiceModel>> getAvailableServices() async {
    try {
      final records = await pocketBaseInstance
          .collection('srv_services')
          .getFullList(sort: '-created', filter: 'is_active = true');

      return records.map((r) => ServiceModel.fromRecord(r)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching services: ${getFriendlyErrorMessage(e)}');
      }
      rethrow;
    }
  }

  Future<List<EquipmentModel>> getUserEquipments(String userId) async {
    try {
      final records = await pocketBaseInstance
          .collection('srv_equipments')
          .getFullList(sort: '-created', filter: 'user = "$userId"');

      return records.map((r) => EquipmentModel.fromRecord(r)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching equipments: ${getFriendlyErrorMessage(e)}');
      }
      rethrow;
    }
  }

  Future<EquipmentModel> addEquipment(Map<String, dynamic> data) async {
    try {
      final record = await pocketBaseInstance
          .collection('srv_equipments')
          .create(body: data);
      return EquipmentModel.fromRecord(record);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error adding equipment: ${getFriendlyErrorMessage(e)}');
      }
      rethrow;
    }
  }

  Future<ServiceRequestModel> createRepairRequest({
    required String userId,
    required String userTier,
    required String serviceId,
    required String equipmentId,
    required String issueDescription,
  }) async {
    if (!_hasValidTier(userTier)) {
      throw Exception(
        'شما دسترسی لازم (کاربر برنزی به بالا) را برای ثبت درخواست ندارید.',
      );
    }

    try {
      final body = {
        'user': userId,
        'service': serviceId,
        'equipment': equipmentId,
        'issue_description': issueDescription,
      };

      final record = await pocketBaseInstance
          .collection('srv_requests')
          .create(body: body);

      return ServiceRequestModel.fromRecord(record);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating request: ${getFriendlyErrorMessage(e)}');
      }
      rethrow;
    }
  }

  Future<List<ServiceRequestModel>> getUserRequests(String userId) async {
    try {
      final records = await pocketBaseInstance
          .collection('srv_requests')
          .getFullList(
            sort: '-created',
            filter: 'user = "$userId"',
            expand: 'service,equipment',
          );

      return records.map((r) => ServiceRequestModel.fromRecord(r)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching requests: ${getFriendlyErrorMessage(e)}');
      }
      rethrow;
    }
  }
}
