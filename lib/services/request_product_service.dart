// lib/services/request_product_service.dart

import 'package:flutter/foundation.dart';

import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';

class RequestProductService {
  Future<void> createProductRequest({
    required String userId,
    required String requestText,
  }) async {
    if (!pocketBaseInstance.authStore.isValid) {
      throw Exception(
        "User is not authenticated. Cannot create a product request.",
      );
    }

    final trimmedText = requestText.trim();
    if (trimmedText.isEmpty) {
      throw Exception("Product request text cannot be empty.");
    }

    try {
      final body = <String, dynamic>{
        "request_text": trimmedText,
        "user": userId,
      };

      await pocketBaseInstance
          .collection('product_requests')
          .create(body: body);
    } catch (e) {
      final friendlyMessage = getFriendlyErrorMessage(e);
      if (kDebugMode) {
        debugPrint(
          'PocketBase Error (Product Request): $friendlyMessage - Details: $e',
        );
      }
      throw Exception(friendlyMessage);
    }
  }
}
