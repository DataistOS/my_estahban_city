// test/features/feat_services/services/services_provider_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/services/services_provider.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('ServicesProvider Unit Tests', () {
    late ServicesProvider servicesProvider;

    setUp(() {
      servicesProvider = ServicesProvider();
    });

    test('initial state values are correct', () {
      expect(servicesProvider.services, isEmpty);
      expect(servicesProvider.userEquipments, isEmpty);
      expect(servicesProvider.userRequests, isEmpty);
      expect(servicesProvider.isLoading, isFalse);
      expect(servicesProvider.isActionLoading, isFalse);
      expect(servicesProvider.errorMessage, isNull);
    });

    test('clearError resets error message and notifies listeners', () {
      bool listenerNotified = false;
      servicesProvider.addListener(() {
        listenerNotified = true;
      });

      servicesProvider.clearError();

      expect(servicesProvider.errorMessage, isNull);
      expect(listenerNotified, isTrue);
    });
  });
}
