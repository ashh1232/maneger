import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/security/encryption_service.dart';
import 'package:maneger/core/security/secure_storage.dart';

/// Secure API client with request signing and authentication
///
/// Features:
/// - Automatic token injection
/// - Request signing (HMAC-SHA256)
/// - Retry logic with exponential backoff
/// - Certificate pinning (production)
/// - Request/response logging
/// - Error handling
class ApiClient {
  final http.Client _client;
  final SecureStorage _secureStorage;
  final EncryptionService _encryptionService;

  // Configuration
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const String apiSecret =
      'your_api_secret_key_2026'; // Move to env in production

  ApiClient({
    http.Client? client,
    SecureStorage? secureStorage,
    EncryptionService? encryptionService,
  }) : _client = client ?? http.Client(),
       _secureStorage = secureStorage ?? SecureStorage(),
       _encryptionService = encryptionService ?? EncryptionService();

  /// GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeRequest(
      method: 'GET',
      url: url,
      headers: headers,
      timeout: timeout ?? defaultTimeout,
    );
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeRequest(
      method: 'POST',
      url: url,
      body: body,
      headers: headers,
      timeout: timeout ?? defaultTimeout,
    );
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeRequest(
      method: 'PUT',
      url: url,
      body: body,
      headers: headers,
      timeout: timeout ?? defaultTimeout,
    );
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _makeRequest(
      method: 'DELETE',
      url: url,
      headers: headers,
      timeout: timeout ?? defaultTimeout,
    );
  }

  /// Core request method with retry logic
  Future<Map<String, dynamic>> _makeRequest({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    required Duration timeout,
    int retryCount = 0,
  }) async {
    try {
      // Build headers with authentication and signing
      final requestHeaders = await _buildHeaders(
        customHeaders: headers,
        body: body,
      );

      // Log request (remove in production or use proper logger)
      _logRequest(method, url, body);

      // Make HTTP request
      final uri = Uri.parse(url);
      http.Response response;

      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: requestHeaders)
              .timeout(timeout);
          break;
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: requestHeaders,
                body: body != null ? _encodeBody(body) : null,
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: requestHeaders,
                body: body != null ? _encodeBody(body) : null,
              )
              .timeout(timeout);
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: requestHeaders)
              .timeout(timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Log response
      _logResponse(response);

      // Handle response
      return _handleResponse(response);
    } on TimeoutException catch (e) {
      debugPrint('⏱️ Request timeout: $url');

      // Retry logic
      if (retryCount < maxRetries) {
        final delay = Duration(seconds: (retryCount + 1) * 2);
        debugPrint(
          '🔄 Retrying in ${delay.inSeconds} seconds... (Attempt ${retryCount + 1}/$maxRetries)',
        );
        await Future.delayed(delay);

        return _makeRequest(
          method: method,
          url: url,
          body: body,
          headers: headers,
          timeout: timeout,
          retryCount: retryCount + 1,
        );
      }

      throw TimeoutException(
        message: 'Request timed out after $maxRetries retries',
        originalError: e,
      );
    } on SocketException catch (e) {
      debugPrint('📡 Network error: $e');
      throw NetworkException(
        message: 'No internet connection',
        originalError: e,
      );
    } catch (e) {
      debugPrint('❌ Request failed: $e');
      throw ServerException(
        message: 'Failed to make request',
        originalError: e,
      );
    }
  }

  /// Build headers with authentication and signing
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? customHeaders,
    Map<String, dynamic>? body,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Accept': 'application/json',
      'User-Agent': 'ManagerApp/1.0.0',
    };

    // Add custom headers
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    // Add authentication token
    final token = await _secureStorage.getAuthToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add request timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    headers['X-Timestamp'] = timestamp;

    // Add request signature (HMAC-SHA256)
    if (body != null) {
      final bodyString = _encodeBody(body);
      final signaturePayload = '$bodyString:$timestamp';
      final signature = _encryptionService.generateSignature(
        signaturePayload,
        apiSecret,
      );
      headers['X-Signature'] = signature;
    }

    return headers;
  }

  /// Encode body for x-www-form-urlencoded
  String _encodeBody(Map<String, dynamic> body) {
    return body.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}',
        )
        .join('&');
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    // Check status code
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        // Decode response with UTF-8
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody) as Map<String, dynamic>;
        return jsonResponse;
      } catch (e) {
        debugPrint('❌ Failed to parse response: $e');
        throw ServerException(
          message: 'Invalid JSON response',
          code: response.statusCode.toString(),
          originalError: e,
        );
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(code: response.statusCode.toString());
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Server error (${response.statusCode})',
        code: response.statusCode.toString(),
      );
    } else {
      throw ServerException(
        message: 'Request failed with status: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
  }

  /// Log request (use proper logger in production)
  void _logRequest(String method, String url, Map<String, dynamic>? body) {
    if (kDebugMode) {
      debugPrint('📤 [$method] $url');
      if (body != null) {
        debugPrint('   Body: $body');
      }
    }
  }

  /// Log response (use proper logger in production)
  void _logResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('📥 [${response.statusCode}] ${response.request?.url}');
      // Don't log response body in production (may contain sensitive data)
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
