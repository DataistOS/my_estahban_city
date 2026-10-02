// test/services/search_history_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/services/search_history_service.dart';

void main() {
  late SearchHistoryService searchHistoryService;

  setUp(() {
    searchHistoryService = SearchHistoryService();
  });

  group('SearchHistoryService Simple Tests', () {
    test('does not throw error and handles empty query gracefully', () async {
      expect(
        () async => await searchHistoryService.saveSearchQuery('   '),
        returnsNormally,
      );
    });
  });
}
