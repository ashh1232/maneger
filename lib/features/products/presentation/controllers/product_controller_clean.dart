import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/products/domain/entities/product.dart';
import 'package:maneger/features/products/domain/entities/category.dart'
    as domain;
import 'package:maneger/features/products/domain/usecases/get_products_usecase.dart';
import 'package:maneger/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:maneger/features/products/domain/usecases/get_banners_usecase.dart';

class ProductControllerClean extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetBannersUseCase getBannersUseCase;

  ProductControllerClean({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getBannersUseCase,
  });

  // State
  final RxList<Product> products = <Product>[].obs;
  final RxList<domain.Category> categories = <domain.Category>[].obs;
  final RxList<domain.Banner> banners = <domain.Banner>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isBannerLoading = false.obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  final RxBool hasMore = true.obs;
  final int limit = 10;

  // UI Controllers & State
  late final ScrollController scrollController;
  late final PageController pageController;
  final RxInt currentBannerIndex = 0.obs;
  final RxBool isScrolled = false.obs;
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    pageController = PageController();

    // Setup scroll listener for pagination
    scrollController.addListener(_onScroll);

    loadInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    pageController.dispose();
    _bannerTimer?.cancel();
    super.onClose();
  }

  void _onScroll() {
    // Pagination logic
    if (scrollController.hasClients) {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent - 300)) {
        loadMoreProducts();
      }
    }
  }

  void toggleScroll(bool scrolled) {
    if (isScrolled.value != scrolled) {
      isScrolled.value = scrolled;
    }
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadBanners(), loadCategories(), loadProducts()]);
  }

  Future<void> loadProducts({bool loadMore = false, String? categoryId}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (!loadMore) {
        currentPage = 1;
        products.clear();
        hasMore.value = true;
      }

      if (!hasMore.value) {
        isLoading.value = false;
        return;
      }

      final result = await getProductsUseCase(
        GetProductsParams(
          page: currentPage,
          limit: limit,
          categoryId: categoryId,
        ),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.rawSnackbar(message: failure.message);
        },
        (newProducts) {
          if (newProducts.length < limit) {
            hasMore.value = false;
          }
          if (loadMore) {
            products.addAll(newProducts);
            print('products');
            print(products);
          } else {
            products.assignAll(newProducts);
            print(products);
          }

          if (newProducts.isNotEmpty) {
            currentPage++;
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      isCategoryLoading.value = true;
      final result = await getCategoriesUseCase();
      print('result');
      print(result);
      result.fold(
        (failure) => print('Error loading categories: ${failure.message}'),
        (cats) => categories.assignAll(cats),
      );
    } finally {
      isCategoryLoading.value = false;
    }
  }

  Future<void> loadBanners() async {
    try {
      isBannerLoading.value = true;
      final result = await getBannersUseCase(NoParams());
      result.fold(
        (failure) => print('Error loading banners: ${failure.message}'),
        (bans) {
          banners.assignAll(bans);
          _startBannerAutoPlay();
        },
      );
    } finally {
      isBannerLoading.value = false;
    }
  }

  void loadMoreProducts() {
    print('asdasd');
    print(hasMore.value);
    print(!isLoading.value);

    if (hasMore.value && !isLoading.value) {
      print('asdsssssssssssssasd');

      loadProducts(loadMore: true);
    }
  }

  void refreshAll() {
    loadInitialData();
  }

  // Banner Logic
  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    if (banners.length <= 1) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients &&
          !pageController.position.isScrollingNotifier.value) {
        int nextPage = (currentBannerIndex.value + 1) % banners.length;
        currentBannerIndex.value = nextPage;

        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void setBannerIndex(int index) {
    currentBannerIndex.value = index;
  }
}
