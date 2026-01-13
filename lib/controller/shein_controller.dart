import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'dart:async';
import 'package:maneger/linkapi.dart';
import '../model/bunner_model.dart';
import '../model/product_model.dart';

class CategoryController extends GetxController
    with GetTickerProviderStateMixin {
  Crud crud = Crud();

  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  late PageController bannerController;
  late AnimationController dotAnimController;
  final RxList<Product> productList = <Product>[].obs;
  final RxList<Bunner> banner = <Bunner>[].obs;
  var isBanLoading = false.obs;

  var isLoading = false.obs;
  var hasMore = true.obs;
  int page = 1;
  String id = '';
  RxString name = 'طلبات'.obs;
  final RxInt currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    bannerController = PageController(initialPage: 0);

    dotAnimController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    checkInitialData();
    _startAutoPlay();
  }

  @override
  void onReady() async {
    // await getData();
    await getBanners();
    await getData();
    name.value = productList.first.catName;

    super.onReady();
  }

  void checkInitialData() {
    final arg = Get.arguments;
    if (arg != null && arg is String) {
      id = arg;
      isLoading.value = false;
    }
  }

  Future<void> getBanners() async {
    if (isBanLoading.value) return;
    statusRequest.value = StatusRequest.loading;

    try {
      isBanLoading.value = true;
      var respo = await crud.postData(AppLink.category, {
        'action': 'get_ban_cat',
        'cat_id': id,
      });
      respo.fold(
        (status) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل: $status",
                duration: Duration(seconds: 2),
              );
            }
          });
        },
        (res) {
          if (res['status'] == 'success') {
            final List<dynamic> decod = res['data'];
            banner.value = decod.map((ban) => Bunner.fromJson(ban)).toList();
            statusRequest.value = StatusRequest.success;
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
      statusRequest.value = StatusRequest.failure;
    }
    isBanLoading.value = false;
  }

  // void _showErrorSnackbar(String message) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!Get.isSnackbarOpen) {
  //       Get.rawSnackbar(
  //         message: message,
  //         snackPosition: SnackPosition.BOTTOM,
  //         duration: const Duration(seconds: 3),
  //         backgroundColor: Colors.black87,
  //       );
  //     }
  //   });
  // }

  Future<void> getData() async {
    if (isLoading.value || !hasMore.value) return;
    statusRequest.value = StatusRequest.loading;

    try {
      isBanLoading.value = true;
      var respo = await crud.postData(AppLink.category, {
        'action': 'get_cat_id',
        'cat_id': id,
      });
      respo.fold(
        (status) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل: $status",
                duration: Duration(seconds: 2),
              );
            }
          });
        },
        (res) {
          if (res['status'] == 'success') {
            final List<dynamic> decod = res['data'];
            productList.value = decod
                .map((ban) => Product.fromJson(ban))
                .toList();
            name.value = productList.first.catName;

            statusRequest.value = StatusRequest.success;
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
      statusRequest.value = StatusRequest.failure;
    } finally {
      isLoading(false);
    }
  }

  void _startAutoPlay() {
    Future.delayed(Duration(seconds: 4), () {
      if (bannerController.hasClients) {
        bannerController.nextPage(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }).then((_) {
      _startAutoPlay();
    });
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = banner.length;
    dotAnimController.forward(from: 0.0);
  }

  @override
  void onClose() {
    bannerController.dispose();
    dotAnimController.dispose();
    super.onClose();
  }
}
