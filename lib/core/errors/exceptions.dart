// lib/core/errors/exceptions.dart

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'خطا در خواندن یا نوشتن اطلاعات محلی'});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'عدم دسترسی به اینترنت'});
}
