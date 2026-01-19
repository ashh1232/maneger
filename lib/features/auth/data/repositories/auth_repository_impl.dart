import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:maneger/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:maneger/features/auth/domain/entities/user.dart';
import 'package:maneger/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
///
/// This class bridges the domain and data layers.
/// It coordinates between remote and local data sources,
/// handles exceptions, and converts them to failures.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call remote data source
      final response = await remoteDataSource.login(email, password);

      // Extract user and token
      final userModel = response.user!;
      final token =
          response.token ?? 'login'; // Fallback for your current backend

      // Cache data locally
      await localDataSource.cacheAuthToken(token);
      await localDataSource.cacheUserData(userModel);

      // Return domain entity
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      debugPrint('🔴 Login failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      // Even if caching fails, login was successful
      debugPrint('⚠️ Cache warning: ${e.message}');
      return const Left(
        CacheFailure(message: 'Login successful but failed to cache data'),
      );
    } on UnauthorizedException {
      return const Left(AuthFailure(message: 'Invalid credentials'));
    } catch (e) {
      debugPrint('❌ Unknown login error: $e');
      return const Left(
        UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signup({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      // Call remote data source
      final response = await remoteDataSource.signup(
        username: username,
        email: email,
        password: password,
        phone: phone,
      );

      // Extract user and token
      final userModel = response.user;
      final token = response.token;

      // Cache data if available
      if (token != null && token.isNotEmpty) {
        await localDataSource.cacheAuthToken(token);
      }
      if (userModel != null) {
        await localDataSource.cacheUserData(userModel);
        return Right(userModel.toEntity());
      }

      // Fallback if no user data in response
      return const Left(
        ServerFailure(message: 'Signup successful but no user data returned'),
      );
    } on ServerException catch (e) {
      debugPrint('🔴 Signup failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on CacheException catch (e) {
      debugPrint('⚠️ Cache warning: ${e.message}');
      return const Left(
        CacheFailure(message: 'Signup successful but failed to cache data'),
      );
    } catch (e) {
      debugPrint('❌ Unknown signup error: $e');
      return const Left(
        UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Get current token
      final token = await localDataSource.getCachedAuthToken();

      // Call remote logout (if token exists)
      if (token != null && token.isNotEmpty) {
        await remoteDataSource.logout(token);
      }

      // Clear local data
      await localDataSource.clearAuthData();

      debugPrint('✅ Logout successful');
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      // Still try to clear local data even if remote logout fails
      try {
        await localDataSource.clearAuthData();
      } catch (_) {}

      return const Left(UnknownFailure(message: 'Logout failed'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Get current user error: $e');
      return const Left(UnknownFailure(message: 'Failed to get user data'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isLoggedIn();
    } catch (e) {
      debugPrint('❌ Is logged in check error: $e');
      return false;
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    // TODO: Implement token refresh logic
    // This would call a refresh token endpoint on your backend
    return const Left(UnknownFailure(message: 'Token refresh not implemented'));
  }
}
