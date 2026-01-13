import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> checkInternet() async {
  try {
    // محاولة فحص الاتصال مع وقت انتظار 5 ثوانٍ كحد أقصى
    final result = await InternetAddress.lookup(
      'google.com',
    ).timeout(const Duration(seconds: 5));

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    // في حال عدم وجود اتصال
    Get.rawSnackbar(
      message: "لا يوجد اتصال بالإنترنت",
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
    );
    return false; // يجب أن تكون false هنا
  } catch (_) {
    return false; // لأي خطأ آخر مثل التايم آوت
  }
}
