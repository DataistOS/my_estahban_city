// lib/features/feat_search/services/search_history_service.dart

import '../../../services/pocketbase_instance.dart';

class SearchHistoryService {
  Future<void> saveSearchQuery(String query) async {
    try {
      if (!pocketBaseInstance.authStore.isValid || query.trim().isEmpty) return;

      final userId = pocketBaseInstance.authStore.model.id;
      final formattedQuery = "استهبان‌من: ${query.trim()}";

      await pocketBaseInstance
          .collection('search_history')
          .create(body: {'user_id': userId, 'search_query': formattedQuery});
    } catch (e) {
      print('خطا: $e');
    }
  }
}
