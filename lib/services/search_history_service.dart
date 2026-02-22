// lib/services/search_history_service.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class SearchHistoryService {
  final PocketBase pb = pocketBaseInstance;

  Future<void> saveSearchQuery(String query) async {
    final currentUser = pb.authStore.model;
    if (currentUser == null || query.trim().isEmpty) {
      return;
    }

    try {
      final body = <String, dynamic>{
        'user_id': currentUser.id,
        'search_query': query,
      };
      await pb.collection('search_history').create(body: body);
    } catch (e) {
      print('Failed to save search history: $e');
    }
  }
}
