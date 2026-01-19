import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/presentation/controllers/cart_controller_clean.dart';
import 'package:maneger/features/products/domain/entities/images.dart';
import 'package:maneger/features/products/domain/entities/product.dart';
import 'package:maneger/features/products/domain/usecases/get_images_usecase.dart';
import 'package:maneger/model/image_model.dart';
import 'package:maneger/model/product_model.dart' as legacy;

class ProductDetailController extends GetxController {
  final GetImagesUseCase getImagesUseCase;

  ProductDetailController({required this.getImagesUseCase});
  final CartControllerClean _cartController = Get.find<CartControllerClean>();

  late final PageController pageController;

  // State
  final Rx<Product?> product = Rx<Product?>(null);
  final RxInt quantity = 1.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isImageLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isFavorite = false.obs;
  final RxList<Images> image = <Images>[].obs;

  @override
  void onInit() {
    isImageLoading.value = true;

    print('1sssssssssssssssssss23123123');

    pageController = PageController();
    _initializeProduct();

    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      setProduct(args);
      print('123123123');
    }
    isImageLoading.value = false;
  }

  void _initializeProduct() {
    final args = Get.arguments;
    if (args != null) {
      setProduct(args);
    } else {
      errorMessage.value = "Product data not found";
    }
  }

  void setProduct(dynamic p) async {
    String? incomingId;
    if (p is Product)
      incomingId = p.id;
    else if (p is legacy.Product)
      incomingId = p.id;

    // 1. 🛑 CHECK GUARD FIRST - Do not update ANY obs variables yet
    if (incomingId == null || product.value?.id == incomingId) return;

    // 2. NOW update state because we know it's a new product

    if (p is Product) {
      product.value = p;
    } else if (p is legacy.Product) {
      product.value = Product(
        id: p.id,
        title: p.title,
        description: p.description,
        price: double.tryParse(p.price) ?? 0.0,
        originalPrice: double.tryParse(p.originalPrice) ?? 0.0,
        imageUrl: p.image,
        categoryId: p.categoryId,
        categoryName: p.catName,
        blurHash: p.blurHash,
      );
    }
    // isImageLoading.value = true;

    await loadProductImages(id: incomingId);
    // isImageLoading.value = false;
  }

  void increaseQuantity() {
    quantity.value++;
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

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

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  Future<void> addToCart() async {
    if (product.value == null) return;

    final cartItem = CartItem(
      product: product.value!,
      quantity: quantity.value,
      isSelected: true,
    );

    Get.rawSnackbar(
      message: "Adding to cart...",
      duration: const Duration(milliseconds: 500),
      snackPosition: SnackPosition.BOTTOM,
    );

    await _cartController.addToCart(cartItem);
  }

  Future<void> loadProductImages({bool loadMore = true, String id = ''}) async {
    if (isLoading.value) return;
    image.value = [];
    try {
      print('object');
      isImageLoading.value = true;
      errorMessage.value = '';

      final result = await getImagesUseCase(GetImagesParams(id: id));

      result.fold((failure) {
        errorMessage.value = failure.message;
        Get.rawSnackbar(message: failure.message);
      }, (newImages) => image.assignAll(newImages));
    } finally {
      print(image);

      isImageLoading.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    pageController.dispose();
    super.onClose();
  }
}
