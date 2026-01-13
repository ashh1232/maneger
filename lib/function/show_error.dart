import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String message) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black87,
      );
    }
  });
}
