/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor

  // App Info
  static const String appName = 'Manager App';
  static const String appVersion = '1.0.0';

  // Storage Keys (migrated from scattered usage)
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyTheme = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyCartItems = 'cart_items';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const int defaultAnimationDuration = 300; // milliseconds

  // Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const int maxCartItems = 99;

  // Default Values
  static const String defaultImage = 'https://via.placeholder.com/400';
  static const String defaultBlurHash = 'UBEVsa9E0M~q~T%ND%x^01-:wbITt8t6%hxa';
}
