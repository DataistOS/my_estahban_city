// test/features/feat_search/services/search_history_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/features/feat_search/services/search_history_service.dart';

void main() {
  group('SearchHistoryService Unit Tests', () {
    late SearchHistoryService searchHistoryService;

    setUp(() {
      searchHistoryService = SearchHistoryService();
    });

    test('saveSearchQuery handles empty query without errors', () async {
      await expectLater(searchHistoryService.saveSearchQuery('   '), completes);
    });

    test('SearchHistoryService instance is created successfully', () {
      expect(searchHistoryService, isNotNull);
    });
  });
}
