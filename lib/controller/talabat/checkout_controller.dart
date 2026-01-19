import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/controller/talabat/tal_map_controller.dart';
import 'package:maneger/features/cart/presentation/controllers/cart_controller_clean.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController extends GetxController {
  // Dependencies
  final TalMapController mapController = Get.find<TalMapController>();
  final Crud _crud = Crud();
  final AuthController authController = Get.find<AuthController>();
  final CartControllerClean cartController = Get.find<CartControllerClean>();

  // State
  final isLoading = false.obs;
  final ismap = false.obs;
  late RxDouble selectedLat = 0.0.obs;
  late RxDouble selectedLong = 0.0.obs;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  // Observable variables
  final RxString selectedPaymentMethod = 'cash'.obs;
  final RxBool isProcessing = false.obs;
  final statusRequest = StatusRequest.loading.obs;

  // Shipping cost
  final RxDouble shippingCost = 5.0.obs;

  @override
  void onInit() async {
    super.onInit();
    loadUserData();
    await _loadFromStorage();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // Load user data to pre-fill form
  void loadUserData() async {
    isLoading.value = false;

    final user = authController.currentUser.value;
    if (user != null) {
      nameController.text = user.userName;
      phoneController.text = user.userPhone ?? '';
      addressController.text = user.userAddress ?? '';
    }
    // Get the latest coordinates directly from the Map Controller
    selectedLat.value = mapController.destinationLatLng.value.latitude;
    selectedLong.value = mapController.destinationLatLng.value.longitude;
    isLoading.value = false;
  }

  Future<void> _loadFromStorage() async {
    ismap.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString('location');

      if (raw == null || raw.isEmpty) return;

      final Map<String, dynamic> locationData = jsonDecode(raw);

      if (locationData.containsKey('lat') && locationData.containsKey('lng')) {
        selectedLat.value = locationData['lat'];
        selectedLong.value = locationData['lng'];
        print(
          "📍 Location loaded: ${selectedLat.value}, ${selectedLong.value}",
        );
      }
    } catch (e) {
      print("⚠️ Error decoding location from storage: $e");
      selectedLat.value = 0.0;
      selectedLong.value = 0.0;
    }
    ismap.value = false;
  }

  // Calculate totals
  double get subtotal => cartController.subtotal;
  double get tax => 0.0; // Tax logic removed/moved
  double get shipping => shippingCost.value;
  double get total => subtotal + tax + shipping;

  // Select payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Validate form
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'الاسم مطلوب', backgroundColor: Colors.red.shade100);
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'رقم الهاتف مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'خطأ',
        'العنوان مطلوب',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    return true;
  }

  // Place order
  Future<void> placeOrder() async {
    if (!validateForm()) return;

    if (cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }

    isProcessing.value = true;
    statusRequest.value = StatusRequest.loading;

    try {
      // Prepare order items
      final orderItems = cartController.cartItems.map((item) {
        return {
          'product_id': item.product.id,
          'product_name': item.product.title,
          'product_image': item.product.imageUrl,
          'product_price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      // Prepare order data
      final orderData = {
        'action': 'create_order',
        'user_id': authController.userId ?? '2',
        'total': total.toStringAsFixed(2),
        'subtotal': subtotal.toStringAsFixed(2),
        'shipping': shipping.toStringAsFixed(2),
        'delivery_name': nameController.text.trim(),
        'delivery_phone': phoneController.text.trim(),
        'delivery_address': addressController.text.trim(),
        'lat': selectedLat.toString(),
        'long': selectedLong.toString(),
        'order_notes': notesController.text.trim(),
        'order_items': jsonEncode(orderItems),
      };

      final response = await _crud.postData(AppLink.order, orderData);

      response.fold(
        (statusReq) {
          statusRequest.value = statusReq;
          isProcessing.value = false;
          Get.snackbar('Error', 'Failed to place order. Please try again.');
        },
        (responseBody) {
          isProcessing.value = false;
          statusRequest.value = StatusRequest.success;

          if (responseBody['status'] == 'success') {
            final orderId = responseBody['order_id'].toString();

            // Clear cart
            cartController.clearCart();

            // Navigate to confirmation screen
            Get.offNamed(
              AppRoutes.orderConfirmation,
              arguments: {'order_id': orderId, 'total': total},
            );
          } else {
            Get.snackbar(
              'Error',
              responseBody['message'] ?? 'Failed to place order',
            );
          }
        },
      );
    } catch (e) {
      isProcessing.value = false;
      statusRequest.value = StatusRequest.serverfailure;
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void openMap() {
    Get.toNamed(AppRoutes.mapScreen);
  }
}
