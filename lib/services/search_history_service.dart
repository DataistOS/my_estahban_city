// lib/services/search_history_service.dart

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class SearchHistoryService {
  final PocketBase pb = pocketBaseInstance;

  Future<void> saveSearchQuery(String query) async {
    final currentUser = pb.authStore.record;
    final trimmedQuery = query.trim();

    if (currentUser == null || trimmedQuery.isEmpty) {
      return;
    }

    try {
      final body = <String, dynamic>{
        'user_id': currentUser.id,
        'search_query': trimmedQuery,
      };
      await pb.collection('search_history').create(body: body);
    } catch (e) {
      debugPrint('Failed to save search history: $e');
    }
  }
}
