import 'dart:convert';

import 'package:get/get.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/model/user_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/linkapi.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);

  final Crud crud = Crud();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  late StatusRequest statusRequest;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await crud.postData(AppLink.login, {
      'username': email,
      'password': password,
    });

    response.fold(
      (failure) {
        errorMessage.value = 'Login failed. Please try again.';
      },
      (data) async {
        if (data['status'] == 'success') {
          final token = 'login';
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          await prefs.setString('auth_token', token);
          isLoggedIn.value = true;
          Get.offAllNamed('/home');
        } else {
          errorMessage.value = data['message'] ?? 'Invalid credentials';
          Get.snackbar('title', (data['status']).toString());
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> signup(String username, String email, String password) async {
    statusRequest = StatusRequest.loading;
    isLoading.value = true;

    final response = await crud.postData(AppLink.signup, {
      'username': username,
      'email': email,
      'password': password,
      'phone': '0518124755',
    });
    var yy = response.fold((l) => l, (r) => r);
    statusRequest = handlingData(yy);

    response.fold(
      (failure) {
        errorMessage.value = 'Signup failed. Please try again.';
      },
      (data) async {
        if (data['status'] == 'success') {
          final token = data['data'];
          final prefs = await SharedPreferences.getInstance();
          if (token != null) {
            await prefs.setString('auth_token', token);
          }
          isLoggedIn.value = true;
          Get.offAllNamed(AppRoutes.home);
        } else {
          errorMessage.value = data['message'] ?? 'Signup failed';
        }
      },
    );

    isLoading.value = false;
  }

  // Save user data after login
  Future<void> saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(user.toJson()));
      currentUser.value = user;
      isLoggedIn.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to save user data');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  String? get userId => currentUser.value?.userId;

  // Update current user
  void updateUser(User user) {
    currentUser.value = user;
    saveUserData(user);
  }
}
