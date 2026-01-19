import 'package:get/get.dart';
import 'package:maneger/class/api_service.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/controller/admin/image_upload_controller.dart';
import 'package:maneger/controller/admin/test_controller.dart';
import 'package:maneger/controller/delivery_controller/deli_map_controller.dart';
import 'package:maneger/controller/talabat/checkout_controller.dart';
import 'package:maneger/controller/talabat/tal_map_controller.dart';
import 'package:maneger/controller/delivery_controller/delivery_home_controller.dart';
import 'package:maneger/controller/product_controller.dart';
import 'package:maneger/controller/auth/auth_controller.dart';
import 'package:maneger/controller/shein_controller.dart';
import 'package:maneger/features/products/domain/usecases/get_images_usecase.dart';
import 'package:maneger/features/products/presentation/controllers/product_detail_controller.dart';
import '../controller/home_screen_controller.dart';

// Imports fixed

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Crud(), permanent: true);
    Get.put(ApiService(), permanent: true);
    // Get.lazyPut(() => SharedPreferences(), fenix: true);
    // Legacy Controllers
    Get.lazyPut<ProductController>(
      () => ProductController(getImagesUseCase: Get.find<GetImagesUseCase>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ProductDetailController(
        getImagesUseCase: Get.find<GetImagesUseCase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    // Get.lazyPut<TalabatController>(() => TalabatController(), fenix: true);
    Get.lazyPut<CheckoutController>(() => CheckoutController(), fenix: true);
    Get.lazyPut<ImageUploadController>(
      () => ImageUploadController(),
      fenix: true,
    );
    Get.lazyPut<TestController>(() => TestController(), fenix: true);
    Get.lazyPut<TalMapController>(() => TalMapController(), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
    Get.lazyPut<HomeScreenController>(
      () => HomeScreenController(),
      fenix: true,
    );

    Get.lazyPut<DeliveryHomeController>(
      () => DeliveryHomeController(),
      fenix: true,
    );
    Get.lazyPut<DeliMapController>(() => DeliMapController(), fenix: true);

    // --- Clean Architecture Dependencies ---
    // (Moved to DependencyInjection.init)
  }
}
