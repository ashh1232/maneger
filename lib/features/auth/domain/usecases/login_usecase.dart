import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/utils/validators.dart';
import 'package:maneger/features/auth/domain/entities/user.dart';
import 'package:maneger/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
///
/// Encapsulates the business logic for logging in a user.
/// Single Responsibility: Handle login flow with validation.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Execute login
  ///
  /// Validates input, then delegates to repository
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Input validation
    if (!Validators.isValidEmail(params.email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }

    if (!Validators.isValidPassword(params.password)) {
      return const Left(
        ValidationFailure(message: 'Password must be at least 6 characters'),
      );
    }

    // Check for unsafe inputs (SQL injection prevention)
    if (!Validators.isSafeString(params.email) ||
        !Validators.isSafeString(params.password)) {
      return const Left(
        ValidationFailure(message: 'Input contains invalid characters'),
      );
    }

    // Delegate to repository
    return await repository.login(
      email: params.email.trim(),
      password: params.password,
    );
  }
}

/// Parameters for login use case
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
