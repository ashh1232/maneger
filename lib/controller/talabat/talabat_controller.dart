import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/bunner_model.dart';
import 'package:maneger/model/cat_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:maneger/model/product_model.dart';

class TalabatController extends GetxController
// with StateMixin<List<Product>>
{
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  //

  final Crud _crud = Crud();
  final RxList<Bunner> banners = <Bunner>[].obs;
  final RxList<Category> catList = <Category>[].obs;
  final RxList<Product> productList = <Product>[].obs;

  var isLoading = false.obs;
  var isBanLoading = false.obs;
  var isCatLoading = false.obs;
  var hasMore = true.obs;
  int page = 1;
  // late StatusRequest statusRequest;
  late final PageController pageController;
  late final ScrollController scrollController; // تعريف متأخر أفضل

  Timer? _bannerTimer;

  final RxInt currentBannerIndex = 0.obs;
  final RxBool isScrolled = false.obs;

  @override
  void onInit() {
    pageController = PageController();
    scrollController = ScrollController();
    initData(); // انقل استدعاء البيانات إلى هنا

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent - 300)) {
        if (!isLoading.value && hasMore.value) {
          getData();
        }
      }
    });
    super.onInit();
  }

  Future<void> initData() async {
    try {
      // 1. نبدأ بحالة التحميل
      statusRequest.value = StatusRequest.loading;

      // 2. ننفذ العمليات الثلاث بالتوازي لسرعة فائقة
      await Future.wait([getBanners(), getCatData(), getData()]);

      // 3. نقيم الحالة النهائية: إذا كانت القائمة فارغة رغم النجاح نعتبرها failure أو empty
      if (productList.isEmpty && catList.isEmpty) {
        statusRequest.value = StatusRequest.failure;
      } else {
        statusRequest.value = StatusRequest.success;
      }

      _startBannerAutoPlay();
    } catch (e) {
      debugPrint("Error: $e");
      statusRequest.value = StatusRequest.failure;
    }
  }

  Future<void> getBanners() async {
    if (isBanLoading.value) return;
    try {
      isBanLoading.value = true;
      var respo = await _crud.postData(AppLink.banner, {});
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
            banners.value = decod.map((ban) => Bunner.fromJson(ban)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    }
    isBanLoading.value = false;
  }

  Future<void> getData() async {
    if (isLoading.value || !hasMore.value) return;
    try {
      isLoading(true);
      var response = await http
          .get(Uri.parse("${AppLink.server}/product2.php?page=$page"))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List newDataList =
            jsonResponse['data']; // Matches the "metadata" PHP structure

        if (newDataList.isEmpty) {
          hasMore(false); // No more records to fetch
        } else {
          List<Product> newProducts = newDataList
              .map((json) => Product.fromJson(json))
              .toList();
          productList.addAll(newProducts);
          page++;
          if (jsonResponse['metadata'] != null) {
            int currentPage = jsonResponse['metadata']['current_page'];
            int totalPages = jsonResponse['metadata']['total_pages'];
            if (currentPage >= totalPages) {
              hasMore(false);
            }
          }
        }
      }
    } catch (e) {
      if (page == 1) _showErrorSnackbar("تحقق من الاتصال بالإنترنت");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCatData() async {
    if (isCatLoading.value) return;
    try {
      isCatLoading.value = true;
      var respo = await _crud.postData(AppLink.cat, {});
      respo.fold(
        (l) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل: $l",
                duration: Duration(seconds: 2),
              );
            }
          });
        },
        (res) {
          if (res['status'] == "success") {
            final List<dynamic> decod = res['data'];
            catList.value = decod.map((e) => Category.fromJson(e)).toList();
          } else {}
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
    }
    // مع Obx، لا نحتاج لاستدعاء update()
    isCatLoading.value = false;
  }

  // دالة مساعدة لعرض الأخطاء دون انهيار الـ Overlay
  void _showErrorSnackbar(String message) {
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

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel(); // إلغاء أي تايمر قديم لتجنب التكرار
    if (banners.length <= 1) return; // لا حاجة للتمرير إذا كان هناك بنر واحد

    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (pageController.hasClients) {
        final next = (currentBannerIndex.value + 1) % banners.length;
        pageController
            .animateToPage(
              next,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
            .then((_) {
              currentBannerIndex.value = next;
            });
      }
    });
  }

  void setBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void toggleScroll(bool scrolled) {
    if (isScrolled.value != scrolled) {
      // فقط حدث القيمة إذا تغيرت الحالة فعلياً
      isScrolled.value = scrolled;
    }
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
