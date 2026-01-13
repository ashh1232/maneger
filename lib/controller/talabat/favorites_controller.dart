import 'package:get/get.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:talabat/controller/auth_controller.dart';
// import 'package:talabat/model/product_model.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  final RxList<Product> favorites = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxSet<String> favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from local storage and optionally sync with server
  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      // Load from local storage first
      await _loadFromStorage();

      // Optionally sync with server if user is logged in
      // await _syncWithServer();
    } finally {
      isLoading.value = false;
    }
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('favorites');
      if (raw == null || raw.isEmpty) return;

      final decoded = jsonDecode(raw) as List<dynamic>;
      favorites.clear();
      favoriteIds.clear();

      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final product = Product.fromJson(item);
          favorites.add(product);
          favoriteIds.add(product.id);
        }
      }
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = favorites.map((p) => p.toJson()).toList();
      await prefs.setString('favorites', jsonEncode(list));
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Check if product is favorite
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  // Toggle favorite
  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFavorite(product.id);
    } else {
      addFavorite(product);
    }
  }

  // Add to favorites
  void addFavorite(Product product) {
    if (!isFavorite(product.id)) {
      favorites.add(product);
      favoriteIds.add(product.id);
      _saveToStorage();
      Get.snackbar('Success', 'Added to favorites');

      // Optionally sync with server
      // _addToServer(product.id);
    }
  }

  // Remove from favorites
  void removeFavorite(String productId) {
    favorites.removeWhere((p) => p.id == productId);
    favoriteIds.remove(productId);
    _saveToStorage();
    Get.snackbar('Removed', 'Removed from favorites');

    // Optionally sync with server
    // _removeFromServer(productId);
  }

  // Sync with server (optional - uncomment if you want server sync)
  // Future<void> _syncWithServer() async {
  //   try {
  //     final userId = authController.userId;
  //     if (userId == null) return;

  //     final response = await _crud.postData(AppLink.favorites, {
  //       'action': 'get_favorites',
  //       'user_id': userId,
  //     });

  //     response.fold(
  //       (statusReq) {},
  //       (responseBody) {
  //         if (responseBody['status'] == 'success') {
  //           final List<dynamic> data = responseBody['data'];
  //           favorites.clear();
  //           favoriteIds.clear();
  //           for (var item in data) {
  //             final product = Product.fromJson(item);
  //             favorites.add(product);
  //             favoriteIds.add(product.id);
  //           }
  //           _saveToStorage();
  //         }
  //       },
  //     );
  //   } catch (e) {}
  // }

  // Add to server
  // Future<void> _addToServer(String productId) async {
  //   try {
  //     final userId = authController.userId;
  //     if (userId == null) return;

  //     await _crud.postData(AppLink.favorites, {
  //       'action': 'add_favorite',
  //       'user_id': userId,
  //       'product_id': productId,
  //     });
  //   } catch (e) {}
  // }

  // Remove from server
  // Future<void> _removeFromServer(String productId) async {
  //   try {
  //     final userId = authController.userId;
  //     if (userId == null) return;

  //     await _crud.postData(AppLink.favorites, {
  //       'action': 'remove_favorite',
  //       'user_id': userId,
  //       'product_id': productId,
  //     });
  //   } catch (e) {}
  // }

  // Clear all favorites
  void clearFavorites() {
    favorites.clear();
    favoriteIds.clear();
    _saveToStorage();
  }
}
