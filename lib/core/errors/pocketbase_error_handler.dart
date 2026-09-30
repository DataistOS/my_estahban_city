// lib/core/errors/pocketbase_error_handler.dart

import 'failures.dart';
import 'exceptions.dart';
import 'package:pocketbase/pocketbase.dart';

String getFriendlyErrorMessage(dynamic error) {
  if (error is ClientException) {
    if (error.statusCode == 400) {
      try {
        final responseData = error.response['data'];
        if (responseData is Map && responseData.isNotEmpty) {
          final firstKey = responseData.keys.first;
          final errorDetail = responseData[firstKey];
          if (errorDetail is Map && errorDetail['message'] != null) {
            return _translatePocketBaseFieldMessage(
              firstKey,
              errorDetail['message'].toString(),
            );
          }
        }
      } catch (_) {}

      if (error.response['message'] != null) {
        return _translateGeneralMessage(error.response['message'].toString());
      }
      return 'اطلاعات وارد شده نامعتبر است.';
    }

    switch (error.statusCode) {
      case 0:
        return 'لطفاً اتصال اینترنت خود را بررسی کنید.';
      case 401:
        return 'ایمیل یا رمز عبور اشتباه است، یا نشست شما منقضی شده است.';
      case 403:
        return 'شما دسترسی لازم به این بخش (محدودیت VIP) را ندارید.';
      case 404:
        return 'اطلاعات مورد نظر یافت نشد.';
      case 429:
        return 'تعداد درخواست‌های شما بیش از حد مجاز است. لطفاً کمی صبر کنید.';
      case 500:
      case 502:
      case 503:
        return 'خطای سرور داخلی رخ داده است. لطفاً بعداً تلاش کنید.';
      default:
        try {
          if (error.response.isNotEmpty && error.response['message'] != null) {
            return _translateGeneralMessage(
              error.response['message'].toString(),
            );
          }
        } catch (_) {}
        return 'خطایی در ارتباط با سرور رخ داد (کد خطا: ${error.statusCode}).';
    }
  } else if (error is NetworkException) {
    return error.message;
  } else if (error is CacheException) {
    return error.message;
  } else if (error is FormatException) {
    return 'خطا در پردازش اطلاعات دریافتی از سرور.';
  }

  return 'خطای ناشناخته رخ داد: $error';
}

Failure mapExceptionToFailure(dynamic error) {
  final message = getFriendlyErrorMessage(error);

  if (error is ClientException) {
    if (error.statusCode == 0) {
      return NetworkFailure(message);
    } else if (error.statusCode == 401) {
      return AuthFailure(message);
    }
  } else if (error is NetworkException) {
    return NetworkFailure(message);
  }

  return ServerFailure(message);
}

String _translateGeneralMessage(String originalMessage) {
  final lower = originalMessage.toLowerCase();
  if (lower.contains('failed to authenticate') ||
      lower.contains('invalid credentials')) {
    return 'نام کاربری یا رمز عبور اشتباه است.';
  }
  if (lower.contains('token_expired') || lower.contains('token is invalid')) {
    return 'نشست شما منقضی شده است. لطفاً مجدداً وارد شوید.';
  }
  if (lower.contains('not found')) {
    return 'مورد نظر یافت نشد.';
  }
  return originalMessage;
}

String _translatePocketBaseFieldMessage(String field, String message) {
  switch (field) {
    case 'email':
      if (message.contains('already')) {
        return 'این ایمیل قبلاً ثبت‌نام شده است.';
      }
      return 'فرمت ایمیل نامعتبر است.';
    case 'password':
      return 'رمز عبور باید حداقل ۸ کاراکتر باشد.';
    case 'passwordConfirm':
      return 'تکرار رمز عبور مطابقت ندارد.';
    default:
      return 'خطا در فیلد $field: $message';
  }
}
