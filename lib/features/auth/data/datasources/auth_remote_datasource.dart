import 'package:flutter/foundation.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/network/api_client.dart';
import 'package:maneger/core/security/encryption_service.dart';
import 'package:maneger/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
///
/// Handles all API calls related to authentication
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> signup({
    required String username,
    required String email,
    required String password,
    String? phone,
  });
  Future<void> logout(String token);
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final EncryptionService encryptionService;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.encryptionService,
  });

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      // Hash password before sending (security best practice)
      final hashedPassword = encryptionService.hashPassword(password);

      // Make API request
      final response = await apiClient.post(
        ApiConstants.login,
        body: {
          'username': email, // Backend uses 'username' field for email
          'password': hashedPassword,
        },
      );

      // Parse response
      final authResponse = AuthResponseModel.fromJson(response);

      // Validate response
      if (!authResponse.isSuccess) {
        throw ServerException(
          message: authResponse.message ?? 'Login failed',
          code: 'LOGIN_FAILED',
        );
      }

      if (authResponse.user == null) {
        throw ServerException(
          message: 'Invalid response: user data missing',
          code: 'INVALID_RESPONSE',
        );
      }

      debugPrint('✅ Login successful: ${authResponse.user!.email}');
      return authResponse;
    } on ServerException {
      // Rethrow server exceptions
      rethrow;
    } on NetworkException {
      // Rethrow network exceptions
      rethrow;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      throw ServerException(message: 'Failed to login', originalError: e);
    }
  }

  @override
  Future<AuthResponseModel> signup({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      // Hash password before sending
      final hashedPassword = encryptionService.hashPassword(password);

      // Make API request
      final response = await apiClient.post(
        ApiConstants.signup,
        body: {
          'username': username,
          'email': email,
          'password': hashedPassword,
          'phone': phone ?? '0000000000', // Backend requires phone
        },
      );

      // Parse response
      final authResponse = AuthResponseModel.fromJson(response);

      // Validate response
      if (!authResponse.isSuccess) {
        throw ServerException(
          message: authResponse.message ?? 'Signup failed',
          code: 'SIGNUP_FAILED',
        );
      }

      debugPrint('✅ Signup successful: ${authResponse.user?.email}');
      return authResponse;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Signup error: $e');
      throw ServerException(message: 'Failed to signup', originalError: e);
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      // If you have a logout endpoint on backend, call it here
      // For now, just log the action
      debugPrint('🔓 Logout requested');

      // Optional: Call backend logout endpoint
      // await apiClient.post(ApiConstants.logout, body: {'token': token});
    } catch (e) {
      debugPrint('⚠️ Logout warning: $e');
      // Don't throw exception on logout - we still want to clear local data
    }
  }
}
