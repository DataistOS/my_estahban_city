// lib/core/errors/failures.dart

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'لطفاً اتصال اینترنت خود را بررسی کنید.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'خطا در احراز هویت. لطفاً دوباره وارد شوید.',
  ]);
}
