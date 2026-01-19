import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/toggle_select_all_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/toggle_selection_usecase.dart';
import 'package:maneger/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:maneger/routes.dart';

class CartControllerClean extends GetxController {
  // Use cases
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final ToggleSelectionUseCase toggleSelectionUseCase;
  final ToggleSelectAllUseCase toggleSelectAllUseCase;
  final ClearCartUseCase clearCartUseCase;

  // State
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool selectAll = true.obs;
  final RxInt selectedCount = 0.obs;

  CartControllerClean({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.toggleSelectionUseCase,
    required this.toggleSelectAllUseCase,
    required this.clearCartUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    isLoading.value = true;
    final result = await getCartUseCase(NoParams());
    result.fold(
      (failure) {
        Get.snackbar('Error', 'Failed to load cart');
      },
      (items) {
        cartItems.assignAll(items);
        _calculateStats();
      },
    );
    isLoading.value = false;
  }

  void _calculateStats() {
    final selected = cartItems.where((item) => item.isSelected).toList();
    selectedCount.value = selected.length;
    selectAll.value =
        cartItems.isNotEmpty && cartItems.every((item) => item.isSelected);
  }

  double get subtotal => cartItems
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + item.totalPrice);

  double get delivery => cartItems.any((item) => item.isSelected) ? 10.0 : 0.0;

  double get total => subtotal + delivery;

  // --- Actions ---

  Future<void> addToCart(CartItem item) async {
    // Optimistic Update
    // Or just reload. Reload is safer for consistency.
    // For now, let's reload to be safe.
    final result = await addToCartUseCase(item);
    result.fold((failure) => Get.snackbar('Error', 'Failed to add to cart'), (
      _,
    ) {
      Get.snackbar(
        'تم الإضافة',
        'تم إضافة المنتج إلى السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      loadCartItems();
    });
  }

  Future<void> removeProduct(int index) async {
    // index in list might differentiate from productId if we allow duplicates?
    // But our logic uses productId.
    final item = cartItems[index];
    final result = await removeFromCartUseCase(item.product.id);
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to remove item'),
      (_) => loadCartItems(),
    );
  }

  Future<void> updateQuantity(int index, int quantity) async {
    final item = cartItems[index];
    final result = await updateCartQuantityUseCase(
      UpdateCartQuantityParams(productId: item.product.id, quantity: quantity),
    );
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to update quantity'),
      (_) => loadCartItems(),
    );
  }

  Future<void> updateSelectedCount(int index, bool isSelected) async {
    final item = cartItems[index];
    final result = await toggleSelectionUseCase(
      ToggleSelectionParams(productId: item.product.id, isSelected: isSelected),
    );
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to update selection'),
      (_) => loadCartItems(), // Reload to ensure sync
    );
  }

  Future<void> toggleSelectAll(bool isSelected) async {
    final result = await toggleSelectAllUseCase(isSelected);
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to update selection'),
      (_) => loadCartItems(),
    );
  }

  Future<void> clearCart() async {
    final result = await clearCartUseCase(NoParams());
    result.fold(
      (failure) => Get.snackbar('Error', 'Failed to clear cart'),
      (_) => loadCartItems(),
    );
  }

  void checkout() {
    if (selectedCount.value == 0) {
      Get.rawSnackbar(
        message: "يرجى اختيار منتج واحد على الأقل",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }
    // Navigate to checkout
    Get.toNamed(AppRoutes.checkout);
  }

  void continueShopping() {
    Get.back();
  }
}
