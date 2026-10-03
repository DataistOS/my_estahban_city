// test/features/services/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockAuthStore extends Mock implements AuthStore {}

void main() {
  late AuthService authService;
  late MockPocketBase mockPb;
  late MockAuthStore mockAuthStore;

  setUp(() {
    mockPb = MockPocketBase();
    mockAuthStore = MockAuthStore();

    when(() => mockAuthStore.record).thenReturn(null);
    when(() => mockAuthStore.onChange).thenAnswer((_) => const Stream.empty());
    when(() => mockPb.authStore).thenReturn(mockAuthStore);

    pocketBaseInstance = mockPb;

    authService = AuthService();
  });

  group('AuthService Mocktail Tests', () {
    test('مقادیر اولیه سرویس باید در حالت پیش‌فرض درست باشند', () {
      expect(authService.isLoading, false);
      expect(authService.errorMessage, isNull);
      expect(authService.currentUser, isNull);
    });

    test('متد clearError باید خطای موجود را پاک کند', () {
      authService.clearError();

      expect(authService.errorMessage, isNull);
    });

    test('متد logout باید اطلاعات کاربر و استور را پاک کند', () async {
      when(() => mockAuthStore.clear()).thenReturn(null);

      await authService.logout();

      expect(authService.currentUser, isNull);
      verify(() => mockAuthStore.clear()).called(1);
    });
  });
}
