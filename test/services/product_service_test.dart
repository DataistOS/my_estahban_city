// test/services/product_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockRecordService extends Mock implements RecordService {}

class MockRecordModel extends Mock implements RecordModel {}

class MockResultList extends Mock implements ResultList<RecordModel> {}

void main() {
  late ProductService productService;
  late MockPocketBase mockPb;
  late MockRecordService mockRecordService;

  setUp(() {
    productService = ProductService();
    mockPb = MockPocketBase();
    mockRecordService = MockRecordService();

    pocketBaseInstance = mockPb;
  });

  group('ProductService Mocktail Tests', () {
    test(
      'getProductByCode should return null immediately when code is empty',
      () async {
        final result = await productService.getProductByCode('');
        expect(result, isNull);
        verifyZeroInteractions(mockPb);
      },
    );

    test(
      'getAllBrands should return unique trimmed brands list successfully',
      () async {
        final mockRecord1 = MockRecordModel();
        final mockRecord2 = MockRecordModel();
        final mockRecord3 = MockRecordModel();

        when(() => mockRecord1.data).thenReturn({'brand': '  Samsung  '});
        when(() => mockRecord2.data).thenReturn({'brand': 'Apple'});
        when(() => mockRecord3.data).thenReturn({'brand': '  Samsung '});

        when(() => mockPb.collection('products')).thenReturn(mockRecordService);
        when(
          () => mockRecordService.getFullList(
            sort: any(named: 'sort'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => [mockRecord1, mockRecord2, mockRecord3]);

        final brands = await productService.getAllBrands();

        expect(brands, ['Samsung', 'Apple']);
        expect(brands.length, 2);
      },
    );

    test(
      'getAllProducts throws and rethrows exception when fetch fails',
      () async {
        when(() => mockPb.collection('products')).thenReturn(mockRecordService);
        when(
          () => mockRecordService.getFullList(
            sort: any(named: 'sort'),
            filter: any(named: 'filter'),
          ),
        ).thenThrow(Exception('Network error'));

        expect(
          () => productService.getAllProducts(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
