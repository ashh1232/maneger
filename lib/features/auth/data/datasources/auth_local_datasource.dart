import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/security/secure_storage.dart';
import 'package:maneger/features/auth/data/models/user_model.dart';

/// Local data source for authentication
///
/// Handles all local storage operations related to authentication
abstract class AuthLocalDataSource {
  Future<void> cacheUserData(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> cacheAuthToken(String token);
  Future<String?> getCachedAuthToken();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await secureStorage.saveUserData(userJson);
      debugPrint('✅ User data cached securely');
    } catch (e) {
      debugPrint('❌ Failed to cache user data: $e');
      throw CacheException(
        message: 'Failed to cache user data',
        originalError: e,
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await secureStorage.getUserData();
      if (userJson == null || userJson.isEmpty) {
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);
      debugPrint('✅ Retrieved cached user: ${user.email}');
      return user;
    } catch (e) {
      debugPrint('❌ Failed to get cached user: $e');
      return null; // Don't throw - just return null if cache is invalid
    }
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await secureStorage.saveAuthToken(token);
      debugPrint('✅ Auth token cached securely');
    } catch (e) {
      debugPrint('❌ Failed to cache auth token: $e');
      throw CacheException(
        message: 'Failed to cache auth token',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getCachedAuthToken() async {
    try {
      final token = await secureStorage.getAuthToken();
      return token;
    } catch (e) {
      debugPrint('❌ Failed to get cached auth token: $e');
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await secureStorage.clearAuthData();
      debugPrint('🗑️ Auth data cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear auth data: $e');
      throw CacheException(
        message: 'Failed to clear auth data',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await secureStorage.isLoggedIn();
    } catch (e) {
      debugPrint('❌ Failed to check login status: $e');
      return false;
    }
  }
}
