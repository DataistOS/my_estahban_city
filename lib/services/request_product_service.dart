// lib/services/request_product_service.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

import 'package:my_estahban_city/services/pocketbase_instance.dart';

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

    try {
      final body = <String, dynamic>{
        "request_text": requestText,
        "user": userId,
      };

      await pocketBaseInstance
          .collection('product_requests')
          .create(body: body);
    } on ClientException catch (e) {
      if (kDebugMode) {
        print('PocketBase Client Error: ${e.response['message']}');
      }
      throw Exception(
        "Failed to create product request: ${e.response['message']}",
      );
    } catch (e) {
      if (kDebugMode) {
        print('Unknown Error: $e');
      }
      rethrow;
    }
  }
}
