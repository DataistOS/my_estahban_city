// test/services/request_product_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/services/request_product_service.dart';

void main() {
  late RequestProductService requestProductService;

  setUp(() {
    requestProductService = RequestProductService();
  });

  group('RequestProductService Simple Tests', () {
    test('throws exception when request text is empty or blank', () async {
      expect(
        () => requestProductService.createProductRequest(
          userId: 'user_123',
          requestText: '   ',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
