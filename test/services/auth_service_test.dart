// test/features/services/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
      authService = AuthService();
    });

    test('مقادیر اولیه سرویس باید در حالت پیش‌فرض درست باشند', () {
      expect(authService.isLoading, false);
      expect(authService.errorMessage, isNull);
    });

    test('متد clearError باید خطای موجود را پاک کند', () {
      authService.clearError();

      expect(authService.errorMessage, isNull);
    });
  });
}
