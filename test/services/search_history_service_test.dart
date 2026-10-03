// test/services/search_history_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/search_history_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockAuthStore extends Mock implements AuthStore {}

class MockRecordModel extends Mock implements RecordModel {}

class MockRecordService extends Mock implements RecordService {}

void main() {
  late SearchHistoryService searchHistoryService;
  late MockPocketBase mockPb;
  late MockAuthStore mockAuthStore;
  late MockRecordModel mockUser;
  late MockRecordService mockRecordService;

  setUp(() {
    mockPb = MockPocketBase();
    mockAuthStore = MockAuthStore();
    mockUser = MockRecordModel();
    mockRecordService = MockRecordService();

    pocketBaseInstance = mockPb;

    searchHistoryService = SearchHistoryService();
  });

  group('SearchHistoryService Mocktail Tests', () {
    test('does not save query when user is not authenticated', () async {
      when(() => mockAuthStore.record).thenReturn(null);
      when(() => mockPb.authStore).thenReturn(mockAuthStore);

      await searchHistoryService.saveSearchQuery('تست جستجو');

      verifyNever(
        () => mockPb.collection(any()).create(body: any(named: 'body')),
      );
    });

    test('does not save query when search query is empty or blank', () async {
      when(() => mockAuthStore.record).thenReturn(mockUser);
      when(() => mockPb.authStore).thenReturn(mockAuthStore);

      await searchHistoryService.saveSearchQuery('   ');

      verifyNever(
        () => mockPb.collection(any()).create(body: any(named: 'body')),
      );
    });

    test(
      'saves search query successfully when user is authenticated and query is valid',
      () async {
        when(() => mockAuthStore.record).thenReturn(mockUser);
        when(() => mockUser.id).thenReturn('user_123');
        when(() => mockPb.authStore).thenReturn(mockAuthStore);
        when(
          () => mockPb.collection('search_history'),
        ).thenReturn(mockRecordService);
        when(
          () => mockRecordService.create(body: any(named: 'body')),
        ).thenAnswer((_) async => mockUser);

        await searchHistoryService.saveSearchQuery('  برنامه نویسی فلاتر  ');

        verify(
          () => mockPb
              .collection('search_history')
              .create(
                body: {
                  'user_id': 'user_123',
                  'search_query': 'برنامه نویسی فلاتر',
                },
              ),
        ).called(1);
      },
    );
  });
}
