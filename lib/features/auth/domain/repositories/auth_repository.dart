import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/auth/domain/entities/user.dart';

/// Repository contract for authentication
///
/// This interface defines the contract that must be implemented
/// by the data layer. The domain layer depends on this abstraction,
/// not on concrete implementations (Dependency Inversion Principle).
abstract class AuthRepository {
  /// Login with email and password
  ///
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Sign up new user
  ///
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> signup({
    required String username,
    required String email,
    required String password,
    String? phone,
  });

  /// Logout current user
  ///
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> logout();

  /// Get current logged-in user
  ///
  /// Returns [User] if logged in, null otherwise
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Refresh authentication token
  ///
  /// Returns new [User] with updated token
  Future<Either<Failure, User>> refreshToken();
}
