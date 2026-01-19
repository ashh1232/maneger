/// API endpoints and configuration constants
///
/// Centralized location for all API-related constants
class ApiConstants {
  ApiConstants._(); // Private constructor to prevent instantiation

  // Base URLs (move to environment variables in production)
  static const String devServer = 'http://192.168.43.19/doc/docana-back';
  static const String prodServer =
      'https://api.yourapp.com'; // Replace with actual

  // Use dev server by default (change for production builds)
  static const String baseUrl = devServer;
  static const String imageBaseUrl = 'http://192.168.43.19/img';

  // API Endpoints
  static const String login = '$baseUrl/login.php';
  static const String signup = '$baseUrl/signup.php';
  static const String profile = '$baseUrl/profile.php';

  // Products
  static const String products = '$baseUrl/product.php';
  static const String product2 = '$baseUrl/product2.php';
  static const String productImages = '$baseUrl/products/pro_images.php';

  // Categories
  static const String categories = '$baseUrl/catt.php';
  static const String addCategory = '$baseUrl/editcat/add_cat.php';
  static const String uploadCategoryImage =
      '$baseUrl/editcat/upload_cat_image.php';
  static const String editCategory = '$baseUrl/editcat/edit_cat.php';

  // Banners
  static const String banners = '$baseUrl/banner.php';
  static const String addBanner = '$baseUrl/banner/add_ban.php';
  static const String uploadBannerImage =
      '$baseUrl/banner/upload_ban_image.php';

  // Orders
  static const String orders = '$baseUrl/order/order.php';
  static const String delivery = '$baseUrl/delivery/delivery_order.php';

  // Favorites
  static const String favorites = '$baseUrl/favorites.php';

  // Admin
  static const String addProduct = '$baseUrl/admin/add_product.php';
  static const String uploadImage = '$baseUrl/admin/upload_image.php';

  // Misc
  static const String update = '$baseUrl/update_test.php';
  static const String addTest = '$baseUrl/add_test.php';

  // Image Paths
  static const String productsImages = '$imageBaseUrl/productsImages/';
  static const String categoriesImages = '$imageBaseUrl/catsImages/';
  static const String bannersImages = '$imageBaseUrl/bannersImages/';

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
