// test/services/product_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/services/product_service.dart';

void main() {
  late ProductService productService;

  setUp(() {
    productService = ProductService();
  });

  group('ProductService Tests', () {
    test(
      'getProductByCode should return null immediately when code is empty',
      () async {
        final result = await productService.getProductByCode('');
        expect(result, isNull);
      },
    );
  });
}
