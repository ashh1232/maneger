// // lib/controllers/product_controller.dart
// import 'package:get/get.dart';
// import 'package:newmanager/db/product_model.dart';
// import 'package:newmanager/db/product_service.dart';

// class TalabatProductController extends GetxController
//     with StateMixin<List<Product>> {
//   final ProductService _productService = ProductService();

//   // Use .obs for reactive variables if you prefer simple reactive programming
//   var productList = <Product>[].obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     isLoading.value = true;
//     try {
//       final products = await _productService.getProducts();
//       productList.assignAll(products); // Update the observable list
//       change(products, status: RxStatus.success()); // For StateMixin usage
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load products: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       change(
//         null,
//         status: RxStatus.error(e.toString()),
//       ); // For StateMixin usage
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> saveNewProduct(
//     String title,
//     String img,
//     String description,
//     int price,
//   ) async {
//     try {
//       await _productService.addProduct(title, img, description, price);
//       Get.snackbar(
//         'Success',
//         'Product added successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       // Refresh the list immediately after adding
//       fetchProducts();
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to add product: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
// }
