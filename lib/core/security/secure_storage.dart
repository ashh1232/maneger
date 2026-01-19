import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:maneger/core/security/encryption_service.dart';

/// Secure storage wrapper for sensitive data
///
/// This replaces SharedPreferences for sensitive data like tokens,
/// user credentials, etc. All data is encrypted before storage.
class SecureStorage {
  // Singleton pattern
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  // Flutter Secure Storage instance
  late final FlutterSecureStorage _secureStorage;

  // Encryption service
  final _encryptionService = EncryptionService();

  /// Storage keys (centralized for easy management)
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyAppSecret = 'app_secret';

  /// Initialize secure storage
  Future<void> initialize() async {
    try {
      // Configure secure storage with encryption
      const androidOptions = AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      );

      const iosOptions = IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
        synchronizable: false,
      );

      _secureStorage = const FlutterSecureStorage(
        aOptions: androidOptions,
        iOptions: iosOptions,
      );

      debugPrint('✅ SecureStorage initialized');
    } catch (e) {
      debugPrint('❌ SecureStorage initialization failed: $e');
      rethrow;
    }
  }

  /// Write encrypted data to secure storage
  ///
  /// Data is encrypted before being stored
  Future<void> write({
    required String key,
    required String value,
    bool encrypt = true,
  }) async {
    try {
      final valueToStore = encrypt
          ? _encryptionService.encryptString(value)
          : value;

      await _secureStorage.write(key: key, value: valueToStore);
      debugPrint('✅ Securely stored: $key');
    } catch (e) {
      debugPrint('❌ Failed to write to secure storage ($key): $e');
      rethrow;
    }
  }

  /// Read and decrypt data from secure storage
  Future<String?> read({required String key, bool decrypt = true}) async {
    try {
      final value = await _secureStorage.read(key: key);

      if (value == null) return null;

      return decrypt ? _encryptionService.decryptString(value) : value;
    } catch (e) {
      debugPrint('❌ Failed to read from secure storage ($key): $e');
      return null;
    }
  }

  /// Delete a key from secure storage
  Future<void> delete({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      debugPrint('🗑️ Deleted from secure storage: $key');
    } catch (e) {
      debugPrint('❌ Failed to delete from secure storage ($key): $e');
    }
  }

  /// Delete all data from secure storage
  ///
  /// Use with caution - typically for logout
  Future<void> deleteAll() async {
    try {
      await _secureStorage.deleteAll();
      debugPrint('🗑️ Cleared all secure storage');
    } catch (e) {
      debugPrint('❌ Failed to clear secure storage: $e');
    }
  }

  /// Check if a key exists
  Future<bool> containsKey({required String key}) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      debugPrint('❌ Failed to check key existence ($key): $e');
      return false;
    }
  }

  /// Get all keys
  Future<Map<String, String>> readAll() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      debugPrint('❌ Failed to read all from secure storage: $e');
      return {};
    }
  }

  // ==================== Convenience Methods ====================

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await write(key: keyAuthToken, value: token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await read(key: keyAuthToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await write(key: keyRefreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await read(key: keyRefreshToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await write(key: keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await read(key: keyUserId);
  }

  /// Save user data (as JSON string)
  Future<void> saveUserData(String userData) async {
    await write(key: keyUserData, value: userData);
  }

  /// Get user data
  Future<String?> getUserData() async {
    return await read(key: keyUserData);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await delete(key: keyAuthToken);
    await delete(key: keyRefreshToken);
    await delete(key: keyUserId);
    await delete(key: keyUserData);
    debugPrint('🔓 Cleared all auth data');
  }
}
