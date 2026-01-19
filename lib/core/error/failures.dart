import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer
///
/// Failures represent errors that can occur during business logic execution.
/// They are used in the domain layer and returned through Either types.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server error occurred', super.code})
    : super(message: message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache error occurred', super.code})
    : super(message: message);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Please check your internet connection',
    super.code,
  }) : super(message: message);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Authentication failed', super.code})
    : super(message: message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({String message = 'Validation failed', super.code})
    : super(message: message);
}

/// Security-related failures
class SecurityFailure extends Failure {
  const SecurityFailure({
    String message = 'Security error occurred',
    super.code,
  }) : super(message: message);
}

/// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({String message = 'Request timed out', super.code})
    : super(message: message);
}

/// Unauthorized access failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized access',
    super.code,
  }) : super(message: message);
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found', super.code})
    : super(message: message);
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unknown error occurred',
    super.code,
  }) : super(message: message);
}
