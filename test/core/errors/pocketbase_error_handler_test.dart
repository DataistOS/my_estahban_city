// test/core/errors/pocketbase_error_handler_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';
import 'package:my_estahban_city/core/errors/exceptions.dart';
import 'package:my_estahban_city/core/errors/failures.dart';

void main() {
  group('PocketBase Error Handler Tests', () {
    test(
      'getFriendlyErrorMessage handles ClientException 400 with field errors',
      () {
        final clientException = ClientException(
          statusCode: 400,
          response: {
            'data': {
              'email': {'message': 'already exists'},
            },
          },
        );

        final message = getFriendlyErrorMessage(clientException);
        expect(message, 'این ایمیل قبلاً ثبت‌نام شده است.');
      },
    );

    test('getFriendlyErrorMessage handles ClientException 401 correctly', () {
      final clientException = ClientException(statusCode: 401, response: {});

      final message = getFriendlyErrorMessage(clientException);
      expect(
        message,
        'ایمیل یا رمز عبور اشتباه است، یا نشست شما منقضی شده است.',
      );
    });

    test('getFriendlyErrorMessage handles ClientException 404 correctly', () {
      final clientException = ClientException(statusCode: 404, response: {});

      final message = getFriendlyErrorMessage(clientException);
      expect(message, 'اطلاعات مورد نظر یافت نشد.');
    });

    test(
      'getFriendlyErrorMessage handles ClientException status 0 (Network error)',
      () {
        final clientException = ClientException(statusCode: 0, response: {});

        final message = getFriendlyErrorMessage(clientException);
        expect(message, 'لطفاً اتصال اینترنت خود را بررسی کنید.');
      },
    );

    test('getFriendlyErrorMessage handles NetworkException correctly', () {
      // تغییر const به final
      final netException = NetworkException(message: 'خطای سفارشی شبکه');
      final message = getFriendlyErrorMessage(netException);
      expect(message, 'خطای سفارشی شبکه');
    });

    test('getFriendlyErrorMessage handles CacheException correctly', () {
      // تغییر const به final
      final cacheException = CacheException(message: 'خطای سفارشی کش');
      final message = getFriendlyErrorMessage(cacheException);
      expect(message, 'خطای سفارشی کش');
    });

    test('getFriendlyErrorMessage handles FormatException correctly', () {
      final formatException = FormatException('Invalid format');
      final message = getFriendlyErrorMessage(formatException);
      expect(message, 'خطا در پردازش اطلاعات دریافتی از سرور.');
    });

    test('getFriendlyErrorMessage handles unknown errors gracefully', () {
      final message = getFriendlyErrorMessage('Some unexpected error');
      expect(message, contains('خطای ناشناخته رخ داد'));
    });

    group('mapExceptionToFailure Tests', () {
      test('maps ClientException status 0 to NetworkFailure', () {
        final clientException = ClientException(statusCode: 0, response: {});
        final failure = mapExceptionToFailure(clientException);
        expect(failure, isA<NetworkFailure>());
      });

      test('maps ClientException status 401 to AuthFailure', () {
        final clientException = ClientException(statusCode: 401, response: {});
        final failure = mapExceptionToFailure(clientException);
        expect(failure, isA<AuthFailure>());
      });

      test('maps general/server errors to ServerFailure', () {
        final clientException = ClientException(statusCode: 500, response: {});
        final failure = mapExceptionToFailure(clientException);
        expect(failure, isA<ServerFailure>());
      });
    });
  });
}
