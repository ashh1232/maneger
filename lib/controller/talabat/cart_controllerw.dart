import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/model/product_model.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  // Observable variables
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final selectedCount = 0.obs;
  final selectAll = true.obs;

  // Sample data - replace with actual API calls
  @override
  void onInit() {
    super.onInit();
    loadProducts();

    // SharedPreferences.getInstance().then((prefs) {
    //   // prefs.clear(); // احذف التعليق وشغل التطبيق مرة واحدة ثم أعده
    //   loadProducts();
    // });
    // Persist whenever products change
    ever(products, (_) => _saveToStorage());
  }

  void loadProducts() async {
    isLoading.value = true;
    try {
      await _loadFromStorage();
      // تحديث العداد المبدئي بناءً على البيانات المحملة
      _syncInitialSelectedCount();
    } finally {
      isLoading.value = false;
    }
  }

  // دالة لمزامنة العداد عند فتح التطبيق
  void _syncInitialSelectedCount() {
    selectedCount.value = products.where((p) => p.isSelected).length;
    selectAll.value =
        products.isNotEmpty && products.every((p) => p.isSelected);
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = products.map((p) => p.toJson()).toList();
      await prefs.setString('cart_items', jsonEncode(list));
    } catch (e) {
      // ignore storage errors for now
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString('cart_items');

      if (raw == null || raw.isEmpty) return;

      final dynamic decodedData = jsonDecode(raw);
      if (decodedData is! List) return;

      final List<Product> loadedProducts = [];

      for (var item in decodedData) {
        try {
          Map<String, dynamic> map = item is String ? jsonDecode(item) : item;
          loadedProducts.add(Product.fromJson(map));
        } catch (e) {
          continue;
        }
      }
      products.assignAll(loadedProducts);
    } catch (e) {
      // تخطي العنصر التالف بدلاً من إيقاف التطبيق بالكامل
    }
  }

  //     products.assignAll(loadedProducts);
  //     print(loadedProducts);
  //   } catch (e) {}
  // }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      products[index].quantity = newQuantity;
      products.refresh();
    }
  }

  void removeProduct(int index) {
    // تقليل العداد إذا كان المنتج المحذوف مختاراً
    if (products[index].isSelected && selectedCount.value > 0) {
      selectedCount.value--;
    }
    products.removeAt(index);
    // تحديث حالة "تحديد الكل" بعد الحذف
    selectAll.value =
        products.isNotEmpty && products.every((p) => p.isSelected);
  }

  void toggleSelectAll(bool value) {
    selectAll.value = value;
    for (var product in products) {
      product.isSelected = value;
    }
    selectedCount.value = value ? products.length : 0;
    products.refresh();
  }

  void updateSelectedCount(int index, bool value) {
    products[index].isSelected = value;

    if (value) {
      selectedCount.value++;
    } else {
      if (selectedCount.value > 0) selectedCount.value--;
    }

    selectAll.value = products.every((p) => p.isSelected);
    products.refresh();
  }

  // الحسابات المالية تعتمد فقط على العناصر المختارة
  double get subtotal => products
      .where((p) => p.isSelected)
      .fold(0.0, (sum, product) => sum + (product.totalPrice));

  double get tax => subtotal * 0.78;
  double get delivery =>
      products.where((p) => p.isSelected).fold(0.0, (sum, product) => sum = 10);
  double get total => subtotal + delivery;

  void checkout() {
    if (products.where((p) => p.isSelected).isEmpty) {
      Get.rawSnackbar(
        message: "يرجى اختيار منتج واحد على الأقل",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }
    Get.toNamed(AppRoutes.checkout);
  }

  void continueShopping() {
    Get.back();
  }
}
