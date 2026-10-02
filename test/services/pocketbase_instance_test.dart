// test/services/pocketbase_instance_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  group('PocketBase Instance Tests', () {
    test('throws exception when POCKETBASE_URL is missing or empty', () async {
      dotenv.testLoad(fileInput: '');

      expect(
        () async => await initializePocketBase(),
        throwsA(isA<Exception>()),
      );
    });

    test('initializes successfully when POCKETBASE_URL is provided', () async {
      dotenv.testLoad(
        fileInput: 'POCKETBASE_URL=https://example.pocketbase.io',
      );

      expect(() async => await initializePocketBase(), returnsNormally);

      expect(pocketBaseInstance, isNotNull);
      expect(pocketBaseInstance.baseUrl, 'https://example.pocketbase.io');
    });
  });
}
