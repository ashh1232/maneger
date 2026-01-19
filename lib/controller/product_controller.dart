// lib/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/talabat/cart_controllerw.dart';
import 'package:maneger/features/products/domain/entities/images.dart';
import 'package:maneger/features/products/domain/usecases/get_images_usecase.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/image_model.dart';
import 'package:maneger/model/product_model.dart';
// import 'package:talabat/controller/cart_controllerw.dart';

// import 'package:talabat/model/product_model.dart';

class ProductController extends GetxController {
  final GetImagesUseCase getImagesUseCase;
  ProductController({required this.getImagesUseCase});

  final RxBool isLoading = false.obs;
  final RxBool isImageLoading = false.obs;
  final RxInt currentImageIndex = 0.obs;
  // final RxString selectedSize = ''.obs;
  // final RxString selectedColor = 'Gray'.obs;
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;
  // final Crud _crud = Crud();

  final CartController cartController = Get.find<CartController>();

  final Rx<Product?> product = Rx<Product?>(null);
  final RxList<Images> image = <Images>[].obs;
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    pageController = PageController();

    // الحصول على البيانات فوراً من الـ arguments
    if (Get.arguments is Product) {
      product.value = Get.arguments;
      // getImages(product.value!.id); // جلب الصور الإضافية فوراً
      print(product.value);
    }
  }

  // دالة لتصفير الحالة (تُستخدم في البداية والنهاية)
  // void resetState() {
  //   quantity.value = 1;
  //   currentImageIndex.value = 0;
  //   isLoading.value = true;
  // }

  void selectImage(int index) {
    currentImageIndex.value = index;
    // أضف هذا السطر لتحريك الـ Slider عند الضغط على الصورة المصغرة
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onReady() async {
    super.onReady();
    // onReady تُنفذ بعد أن تكون الواجهة قد استقرت وتم إنشاء الـ Overlay
    Future.delayed(const Duration(milliseconds: 300), () {
      loadProduct();
    });
    // await getImages('product.value.id');
  }

  // Future<void> getImages(String id) async {
  //   if (id.isEmpty) return;
  //   if (isImageLoading.value) return;
  //   try {
  //     isImageLoading.value = true;
  //     var respo = await _crud.postData(AppLink.proImages, {'pro_id': id});
  //     if (isClosed) return;
  //     respo.fold(
  //       (status) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           if (Get.context != null && !Get.isSnackbarOpen) {
  //             Get.rawSnackbar(
  //               message: "خطأ في التحميل: $status",
  //               duration: Duration(seconds: 2),
  //             );
  //           }
  //         });
  //       },
  //       (res) {
  //         if (res['status'] == 'success') {
  //           final List<dynamic> decod = res['data'];
  //           image.value = [];
  //           image.value = decod.map((ban) => Imagesm.fromJson(ban)).toList();
  //         } else {}
  //       },
  //     );
  //   } catch (e) {
  //     Get.snackbar(('error'), 'error $e');
  //   }
  //   isImageLoading.value = false;
  // }

  Future<void> loadCategories() async {
    try {
      isImageLoading.value = true;
      final result = await getImagesUseCase(GetImagesParams());
      print('result');
      print(result);
      result.fold(
        (failure) => print('Error loading categories: ${failure.message}'),
        (cats) => image.assignAll(cats),
      );
    } finally {
      isImageLoading.value = false;
    }
  }

  void loadProduct() {
    isLoading.value = true;
    final arg = Get.arguments;

    if (arg != null && arg is Product) {
      product.value = arg;
      isLoading.value = false;
    }
  }

  // void previousImage() {
  //   if (currentImageIndex.value > 0) {
  //     currentImageIndex.value--;
  //   }
  // }

  // void selectImage(int index) {
  //   currentImageIndex.value = index;
  // }

  void changeSize(String size) {
    // selectedSize.value = size;
  }

  void changeColor(String color) {
    // selectedColor.value = color;
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

  // @override
  // void onClose() {
  //   resetState(); // تنظيف البيانات عند إغلاق الصفحة
  //   product.value = null; // إفراغ الكائن من الذاكرة
  //   super.onClose();
  // }
  @override
  void onClose() {
    pageController.dispose(); // إغلاق المتحكم أهم خطوة هنا
    product.value = null;
    super.onClose();
  }
}
