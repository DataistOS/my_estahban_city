// test/core/errors/pocketbase_error_handler_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';
import 'package:my_estahban_city/core/errors/failures.dart';

void main() {
  group('PocketBase Error Handler Tests', () {
    test(
      'Should return correct message for ClientException with status 0 (Network Error)',
      () {
        final exception = ClientException(
          url: Uri.parse('http://example.com'),
          statusCode: 0,
          response: {},
        );

        final message = getFriendlyErrorMessage(exception);
        final failure = mapExceptionToFailure(exception);

        expect(message, 'لطفاً اتصال اینترنت خود را بررسی کنید.');
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, message);
      },
    );

    test(
      'Should return correct message for ClientException with status 401 (Auth Error)',
      () {
        final exception = ClientException(
          url: Uri.parse('http://example.com'),
          statusCode: 401,
          response: {},
        );

        final message = getFriendlyErrorMessage(exception);
        final failure = mapExceptionToFailure(exception);

        expect(
          message,
          'ایمیل یا رمز عبور اشتباه است، یا نشست شما منقضی شده است.',
        );
        expect(failure, isA<AuthFailure>());
      },
    );

    test(
      'Should return correct message for ClientException with status 403 (Forbidden)',
      () {
        final exception = ClientException(
          url: Uri.parse('http://example.com'),
          statusCode: 403,
          response: {},
        );

        final message = getFriendlyErrorMessage(exception);
        expect(message, 'شما دسترسی لازم به این بخش (محدودیت VIP) را ندارید.');
      },
    );

    test('Should handle 400 Bad Request with field validation errors', () {
      final exception = ClientException(
        url: Uri.parse('http://example.com'),
        statusCode: 400,
        response: {
          'data': {
            'email': {'message': 'The email is already in use.'},
          },
        },
      );

      final message = getFriendlyErrorMessage(exception);
      expect(message, 'این ایمیل قبلاً ثبت‌نام شده است.');
    });

    test('Should handle 400 Bad Request with general message', () {
      final exception = ClientException(
        url: Uri.parse('http://example.com'),
        statusCode: 400,
        response: {'message': 'Invalid credentials provided'},
      );

      final message = getFriendlyErrorMessage(exception);
      expect(message, 'نام کاربری یا رمز عبور اشتباه است.');
    });

    test('Should handle unknown exceptions gracefully', () {
      final unknownError = Exception('Something went wrong');

      final message = getFriendlyErrorMessage(unknownError);
      expect(message, contains('خطای ناشناخته رخ داد'));
    });
  });
}
