import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_model.dart';
import 'package:maneger/model/user_model.dart';
// import 'package:talabat/class/crud.dart';
// import 'package:talabat/class/statusrequest.dart';
// import 'package:talabat/controller/auth_controller.dart';
// import 'package:talabat/linkapi.dart';
// import 'package:talabat/model/order_model.dart';
// import 'package:talabat/model/user_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final Crud _crud = Crud();
  final AuthController authController = Get.find<AuthController>();

  // Observable variables
  final Rx<User?> user = Rx<User?>(null);
  final RxList<Order> orders = <Order>[].obs;
  final statusRequest = StatusRequest.loading.obs;
  final RxBool isEditing = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadOrders();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.onClose();
  }

  // Load user profile
  Future<void> loadProfile() async {
    statusRequest.value = StatusRequest.loading;

    try {
      final userId = authController.userId;
      if (userId == null) {
        statusRequest.value = StatusRequest.failure;
        return;
      }

      final response = await _crud.postData(AppLink.profile, {
        'action': 'get_profile',
        'user_id': userId,
      });

      response.fold(
        (statusReq) {
          statusRequest.value = statusReq;
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            user.value = User.fromJson(responseBody['data']);
            _fillFormControllers();
            statusRequest.value = StatusRequest.success;
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      statusRequest.value = StatusRequest.serverfailure;
    }
  }

  // Fill form controllers with user data
  void _fillFormControllers() {
    if (user.value != null) {
      nameController.text = user.value!.userName;
      phoneController.text = user.value!.userPhone ?? '';
      addressController.text = user.value!.userAddress ?? '';
      cityController.text = user.value!.userCity ?? '';
      countryController.text = user.value!.userCountry ?? '';
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      _fillFormControllers(); // Reset form if canceling edit
    }
  }

  // Update profile
  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }

    statusRequest.value = StatusRequest.loading;

    try {
      final userId = authController.userId;
      if (userId == null) return;

      final response = await _crud.postData(AppLink.profile, {
        'action': 'update_profile',
        'user_id': userId,
        'user_name': nameController.text.trim(),
        'user_phone': phoneController.text.trim(),
        'user_address': addressController.text.trim(),
        'user_city': cityController.text.trim(),
        'user_country': countryController.text.trim(),
      });

      response.fold(
        (statusReq) {
          statusRequest.value = statusReq;
          Get.snackbar('Error', 'Failed to update profile');
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            Get.snackbar(
              'Success',
              'Profile updated successfully',
              backgroundColor: Colors.green.shade100,
            );
            loadProfile(); // Reload profile
            isEditing.value = false;
            statusRequest.value = StatusRequest.success;
          } else {
            Get.snackbar('Error', responseBody['message'] ?? 'Update failed');
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      statusRequest.value = StatusRequest.serverfailure;
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Load user orders
  Future<void> loadOrders() async {
    try {
      final userId = authController.userId;
      if (userId == null) return;

      final response = await _crud.postData(AppLink.order, {
        'action': 'get_orders',
        'user_id': userId,
      });

      response.fold(
        (statusReq) {
          // Handle error silently for orders
        },
        (responseBody) {
          if (responseBody['status'] == 'success') {
            final List<dynamic> data = responseBody['data'];
            orders.value = data.map((json) => Order.fromJson(json)).toList();
          }
        },
      );
    } catch (e) {
      // Handle error silently
    }
  }

  // Logout
  void logout() {
    authController.logout();
  }
}
