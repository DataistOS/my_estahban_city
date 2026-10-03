// test/services/request_product_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/request_product_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}
class MockAuthStore extends Mock implements AuthStore {}
class MockRecordService extends Mock implements RecordService {}
class MockRecordModel extends Mock implements RecordModel {}

void main() {
  late RequestProductService requestProductService;
  late MockPocketBase mockPb;
  late MockAuthStore mockAuthStore;
  late MockRecordService mockRecordService;
  late MockRecordModel mockRecordModel;

  setUp(() {
    requestProductService = RequestProductService();
    mockPb = MockPocketBase();
    mockAuthStore = MockAuthStore();
    mockRecordService = MockRecordService();
    mockRecordModel = MockRecordModel();

    pocketBaseInstance = mockPb;
  });

  group('RequestProductService Mocktail Tests', () {
    test('throws exception when user is not authenticated', () async {
      when(() => mockAuthStore.isValid).thenReturn(false);
      when(() => mockPb.authStore).thenReturn(mockAuthStore);

      expect(
            () => requestProductService.createProductRequest(
          userId: 'user_123',
          requestText: 'محصول تستی',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception when request text is empty or blank', () async {
      when(() => mockAuthStore.isValid).thenReturn(true);
      when(() => mockPb.authStore).thenReturn(mockAuthStore);

      expect(
            () => requestProductService.createProductRequest(
          userId: 'user_123',
          requestText: '   ',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('creates product request successfully when user is authenticated and text is valid', () async {
      when(() => mockAuthStore.isValid).thenReturn(true);
      when(() => mockPb.authStore).thenReturn(mockAuthStore);
      when(() => mockPb.collection('product_requests')).thenReturn(mockRecordService);
      when(() => mockRecordService.create(body: any(named: 'body')))
          .thenAnswer((_) async => mockRecordModel);

      await requestProductService.createProductRequest(
        userId: 'user_123',
        requestText: '  گوشی موبایل شیائومی  ',
      );

      verify(() => mockPb.collection('product_requests').create(
        body: {
          'request_text': 'گوشی موبایل شیائومی',
          'user': 'user_123',
        },
      )).called(1);
    });
  });
}
