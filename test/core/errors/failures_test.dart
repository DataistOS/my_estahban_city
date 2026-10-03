// test/core/errors/failures_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/core/errors/failures.dart';

void main() {
  group('Failures Unit Tests', () {
    test('ServerFailure should store the provided message correctly', () {
      const failure = ServerFailure('خطای سرور رخ داده است');

      expect(failure.message, 'خطای سرور رخ داده است');
      expect(failure, isA<Failure>());
    });

    test('NetworkFailure should use default message when none is provided', () {
      const failure = NetworkFailure();

      expect(failure.message, 'لطفاً اتصال اینترنت خود را بررسی کنید.');
      expect(failure, isA<Failure>());
    });

    test('NetworkFailure should store custom message when provided', () {
      const failure = NetworkFailure('خطای سفارشی شبکه');

      expect(failure.message, 'خطای سفارشی شبکه');
    });

    test('AuthFailure should use default message when none is provided', () {
      const failure = AuthFailure();

      expect(failure.message, 'خطا در احراز هویت. لطفاً دوباره وارد شوید.');
      expect(failure, isA<Failure>());
    });

    test('AuthFailure should store custom message when provided', () {
      const failure = AuthFailure('توکن منقضی شده است');

      expect(failure.message, 'توکن منقضی شده است');
    });
  });
}
