// lib/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat/cart_controllerw.dart';
import 'package:maneger/model/product_model.dart';
// import 'package:talabat/controller/cart_controllerw.dart';

// import 'package:talabat/model/product_model.dart';

class ProductController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxString selectedSize = ''.obs;
  final RxString selectedColor = 'Gray'.obs;
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;

  final CartController cartController = Get.find<CartController>();

  final Rx<Product?> product = Rx<Product?>(null);

  @override
  void onInit() {
    super.onInit();
    resetState(); // التأكد من تصفير الحالة عند البدء
    checkInitialData();
  }

  // دالة لتصفير الحالة (تُستخدم في البداية والنهاية)
  void resetState() {
    quantity.value = 1;
    currentImageIndex.value = 0;
    isLoading.value = true;
  }

  void checkInitialData() {
    final arg = Get.arguments;
    if (arg != null && arg is Product) {
      product.value = arg;
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // onReady تُنفذ بعد أن تكون الواجهة قد استقرت وتم إنشاء الـ Overlay
    Future.delayed(const Duration(milliseconds: 300), () {
      loadProduct();
    });
  }

  void loadProduct() {
    isLoading.value = true;
    final arg = Get.arguments;

    if (arg != null && arg is Product) {
      product.value = arg;
      isLoading.value = false;
    }
  }

  void addToCart({
    required String id,
    required String img,
    required String title,
    required String price,
  }) {
    // 1. التأكد من وجود كائن المنتج لتجنب خطأ الـ Null في الوصف أو السعر الأصلي
    final currentProduct = product.value;

    final cartItem = Product(
      id: id,
      title: title,
      image: img,
      originalPrice: currentProduct?.originalPrice ?? "0",
      description: currentProduct?.description ?? "",
      price: price,
      quantity: quantity.value,
      categoryId: '1',
      blurHash: '',
    );

    // 2. البحث عن المنتج في السلة
    final int existingIndex = cartController.products.indexWhere(
      (p) => p.id == id,
    );

    if (existingIndex >= 0) {
      // 3. الحل الآمن لتحديث الكمية:
      // الحصول على الكائن الحالي أولاً والتأكد من أنه ليس null
      var existingProduct = cartController.products[existingIndex];

      // تحديث الكمية في الكائن المحلي
      existingProduct.quantity += quantity.value;

      // استبدال الكائن القديم بالجديد في القائمة لضمان التحديث (أكثر أماناً من +=)
      cartController.products[existingIndex] = existingProduct;

      // إخطار واجهة المستخدم بالتغيير
      cartController.products.refresh();

      Get.snackbar(
        'تم التحديث',
        'تمت زيادة الكمية في السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } else {
      // 4. إضافة منتج جديد
      cartController.products.add(cartItem);

      Get.snackbar(
        'تم الإضافة',
        'تم إضافة المنتج إلى السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    }
  }

  void previousImage() {
    if (currentImageIndex.value > 0) {
      currentImageIndex.value--;
    }
  }

  void selectImage(int index) {
    currentImageIndex.value = index;
  }

  void changeSize(String size) {
    selectedSize.value = size;
  }

  void changeColor(String color) {
    selectedColor.value = color;
  }

  void increaseQuantity() {
    // Increment the reactive quantity variable
    quantity.value++;
  }

  void decreaseQuantity() {
    // Prevent quantity from going below 1
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  @override
  void onClose() {
    resetState(); // تنظيف البيانات عند إغلاق الصفحة
    product.value = null; // إفراغ الكائن من الذاكرة
    super.onClose();
  }
}
