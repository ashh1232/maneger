import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
///
/// Handles the business logic for logging out a user.
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Execute logout
  ///
  /// Clears authentication tokens and user data
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
