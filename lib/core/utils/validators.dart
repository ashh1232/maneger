/// Input validation utilities
///
/// Provides validation methods for user inputs with security in mind
class Validators {
  Validators._(); // Private constructor

  // Email validation regex
  static final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Phone validation regex (international format)
  static final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');

  // Username validation (alphanumeric, underscore, hyphen)
  static final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');

  // Dangerous characters for SQL injection prevention
  static final dangerousCharsRegex = RegExp(r'''[;'"\\<>]''');

  /// Validate email address
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return emailRegex.hasMatch(email.trim());
  }

  /// Validate phone number
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return phoneRegex.hasMatch(phone.trim());
  }

  /// Validate username
  static bool isValidUsername(String? username) {
    if (username == null || username.isEmpty) return false;
    return usernameRegex.hasMatch(username.trim());
  }

  /// Validate password strength
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    if (password.length < 6) return false; // Minimum length

    // Optional: Add strength requirements
    // bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    // bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    // bool hasDigits = password.contains(RegExp(r'[0-9]'));
    // bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return true;
  }

  /// Check if string contains dangerous characters
  static bool isSafeString(String? input) {
    if (input == null || input.isEmpty) return true;
    return !dangerousCharsRegex.hasMatch(input);
  }

  /// Sanitize string by removing dangerous characters
  static String sanitize(String input) {
    return input.replaceAll(dangerousCharsRegex, '');
  }

  /// Validate required field
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate minimum length
  static bool hasMinLength(String? value, int minLength) {
    if (value == null) return false;
    return value.trim().length >= minLength;
  }

  /// Validate maximum length
  static bool hasMaxLength(String? value, int maxLength) {
    if (value == null) return true;
    return value.trim().length <= maxLength;
  }

  /// Validate length range
  static bool hasLengthBetween(String? value, int min, int max) {
    if (value == null) return false;
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Validate numeric string
  static bool isNumeric(String? value) {
    if (value == null || value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  /// Validate URL
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

/// Validation error messages
class ValidationMessages {
  ValidationMessages._();

  static const String emptyField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidUsername =
      'Username must be 3-20 characters (letters, numbers, _, -)';
  static const String weakPassword = 'Password must be at least 6 characters';
  static const String unsafeInput = 'Input contains invalid characters';
  static const String invalidUrl = 'Please enter a valid URL';
}
