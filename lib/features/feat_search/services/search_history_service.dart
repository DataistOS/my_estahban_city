// lib/features/feat_search/services/search_history_service.dart

import 'package:flutter/foundation.dart';
import '../../../services/pocketbase_instance.dart';

class SearchHistoryService {
  Future<void> saveSearchQuery(String query) async {
    try {
      if (!pocketBaseInstance.authStore.isValid || query.trim().isEmpty) return;

      final currentUser = pocketBaseInstance.authStore.record;
      if (currentUser == null) return;

      final userId = currentUser.id;
      final formattedQuery = "استهبان‌من: ${query.trim()}";

      await pocketBaseInstance
          .collection('search_history')
          .create(body: {'user_id': userId, 'search_query': formattedQuery});
    } catch (e) {
      if (kDebugMode) {
        debugPrint('خطا در ذخیره تاریخچه جستجو: $e');
      }
    }
  }
}
