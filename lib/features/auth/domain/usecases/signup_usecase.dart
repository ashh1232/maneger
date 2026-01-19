import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/utils/validators.dart';
import 'package:maneger/features/auth/domain/entities/user.dart';
import 'package:maneger/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user signup
///
/// Encapsulates the business logic for registering a new user.
/// Single Responsibility: Handle sign up flow with validation.
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  /// Execute signup
  ///
  /// Validates input, then delegates to repository
  Future<Either<Failure, User>> call(SignupParams params) async {
    // Validate username
    if (!Validators.hasLengthBetween(params.username, 3, 50)) {
      return const Left(
        ValidationFailure(
          message: 'Username must be between 3 and 50 characters',
        ),
      );
    }

    // Validate email
    if (!Validators.isValidEmail(params.email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }

    // Validate password
    if (!Validators.isValidPassword(params.password)) {
      return const Left(
        ValidationFailure(message: 'Password must be at least 6 characters'),
      );
    }

    // Validate password confirmation
    if (params.password != params.confirmPassword) {
      return const Left(ValidationFailure(message: 'Passwords do not match'));
    }

    // Validate phone (if provided)
    if (params.phone != null &&
        params.phone!.isNotEmpty &&
        !Validators.isValidPhone(params.phone!)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid phone number'),
      );
    }

    // Check for unsafe inputs
    if (!Validators.isSafeString(params.username) ||
        !Validators.isSafeString(params.email) ||
        !Validators.isSafeString(params.password)) {
      return const Left(
        ValidationFailure(message: 'Input contains invalid characters'),
      );
    }

    // Delegate to repository
    return await repository.signup(
      username: params.username.trim(),
      email: params.email.trim(),
      password: params.password,
      phone: params.phone?.trim(),
    );
  }
}

/// Parameters for signup use case
class SignupParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;

  const SignupParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    confirmPassword,
    phone,
  ];
}
