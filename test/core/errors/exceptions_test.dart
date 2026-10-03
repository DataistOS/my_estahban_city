// test/core/errors/exceptions_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/core/errors/exceptions.dart';

void main() {
  group('Exceptions Unit Tests', () {
    test('ServerException should store message and status code correctly', () {
      final exception = ServerException(
        message: 'Internal Server Error',
        statusCode: 500,
      );

      expect(exception.message, 'Internal Server Error');
      expect(exception.statusCode, 500);
      expect(exception, isA<Exception>());
    });

    test('CacheException should use default message when not provided', () {
      final exception = CacheException();

      expect(exception.message, 'خطا در خواندن یا نوشتن اطلاعات محلی');
      expect(exception, isA<Exception>());
    });

    test('CacheException should store custom message when provided', () {
      final exception = CacheException(message: 'خطای سفارشی کش');

      expect(exception.message, 'خطای سفارشی کش');
    });

    test('NetworkException should use default message when not provided', () {
      final exception = NetworkException();

      expect(exception.message, 'عدم دسترسی به اینترنت');
      expect(exception, isA<Exception>());
    });

    test('NetworkException should store custom message when provided', () {
      final exception = NetworkException(message: 'قطع اتصال شبکه');

      expect(exception.message, 'قطع اتصال شبکه');
    });
  });
}
