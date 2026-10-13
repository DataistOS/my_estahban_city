// test/features/feat_services/services/repair_service_client_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/services/repair_service_client.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('RepairServiceClient Unit Tests', () {
    late RepairServiceClient client;

    setUp(() {
      client = RepairServiceClient();
    });

    test('RepairServiceClient instance is created successfully', () {
      expect(client, isNotNull);
    });

    test(
      'createRepairRequest throws exception when user tier is invalid or free',
      () async {
        expect(
          () async => await client.createRepairRequest(
            userId: 'user_123',
            userTier: 'free',
            serviceId: 'srv_1',
            equipmentId: 'eq_1',
            issueDescription: 'تست خطای سطح دسترسی',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'createRepairRequest throws exception when user tier is null or empty',
      () async {
        expect(
          () async => await client.createRepairRequest(
            userId: 'user_123',
            userTier: '',
            serviceId: 'srv_1',
            equipmentId: 'eq_1',
            issueDescription: 'تست سطح دسترسی خالی',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
