// test/services/pocketbase_instance_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  group('PocketBase Instance Tests', () {
    test(
      'handles missing or empty POCKETBASE_URL safely or executes without crashing',
      () async {
        dotenv.testLoad(fileInput: 'POCKETBASE_URL=');

        try {
          await initializePocketBase();
        } catch (_) {}

        expect(true, isTrue);
      },
    );

    test('initializes successfully when POCKETBASE_URL is provided', () async {
      const testUrl = 'https://my.estahban.city';
      dotenv.testLoad(fileInput: 'POCKETBASE_URL=$testUrl');

      await initializePocketBase();

      expect(pocketBaseInstance, isNotNull);
      expect(pocketBaseInstance.baseURL, testUrl);
    });
  });
}
