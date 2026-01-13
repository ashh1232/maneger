import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/controller/talabat/cart_controllerw.dart';
import 'package:maneger/controller/talabat/tal_map_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';

class CheckoutController extends GetxController {
  //////////////
  // أضف هذا السطر مع الـ controllers الأخرى
  final TalMapController mapController = Get.find<TalMapController>();

  // لتخزين الإحداثيات المختارة
  double get selectedLat => mapController.destinationLatLng.value.latitude;
  double get selectedLong => mapController.destinationLatLng.value.longitude;
  /////////
  final Crud _crud = Crud();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();

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
  void onInit() {
    super.onInit();
    loadUserData();
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
  void loadUserData() {
    final user = authController.currentUser.value;
    if (user != null) {
      nameController.text = user.userName;
      phoneController.text = user.userPhone ?? '545';
      addressController.text = user.userAddress ?? '';
    }
  }

  // Calculate totals
  double get subtotal => cartController.subtotal;
  double get tax => cartController.tax;
  double get shipping => shippingCost.value;
  double get total => subtotal + tax + shipping;

  // Select payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Validate form
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your address',
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
    // if (cityController.text.trim().isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Please enter your city',
    //     backgroundColor: Colors.red.shade100,
    //   );
    //   return false;
    // }
    // if (countryController.text.trim().isEmpty) {
    //   Get.snackbar(
    //     'Error',
    //     'Please enter your country',
    //     backgroundColor: Colors.red.shade100,
    //   );
    //   return false;
    // }
    return true;
  }

  // Place order
  Future<void> placeOrder() async {
    if (!validateForm()) return;

    if (cartController.products.isEmpty) {
      Get.snackbar('Error', 'Your cart is empty');
      return;
    }

    isProcessing.value = true;
    statusRequest.value = StatusRequest.loading;

    try {
      // Prepare order items
      final orderItems = cartController.products.map((product) {
        return {
          'product_id': product.id,
          'product_name': product.title,
          'product_image': product.image,
          'product_price': product.price,
          'quantity': product.quantity,
        };
      }).toList();
      // Prepare order data
      final orderData = {
        'action': 'create_order',
        'user_id':
            authController.userId ?? '2', // Default to 1 if not logged in
        'total': total.toStringAsFixed(2),

        'subtotal': subtotal.toStringAsFixed(2),
        // 'tax': tax.toStringAsFixed(2),
        'shipping': shipping.toStringAsFixed(2),

        'delivery_name': nameController.text.trim(),
        'delivery_phone': phoneController.text.trim(),
        'delivery_address': addressController.text.trim(),
        'lat': selectedLat.toString(),
        'long': selectedLong.toString(),
        'order_notes': notesController.text.trim(),
        'order_items': jsonEncode(orderItems),
      };

      // Send request to API

      // print((authController.userId).runtimeType);

      final response = await _crud.postData(AppLink.order, orderData);

      response.fold(
        (statusReq) {
          // Error
          statusRequest.value = statusReq;
          isProcessing.value = false;
          Get.snackbar('Error', 'Failed to place order. Please try again.');
        },
        (responseBody) {
          // Success
          isProcessing.value = false;
          statusRequest.value = StatusRequest.success;

          if (responseBody['status'] == 'success') {
            final orderId = responseBody['order_id'].toString();

            // Clear cart
            cartController.products.clear();

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
}
