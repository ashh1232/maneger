// // lib/controllers/product_controller.dart
// import 'package:get/get.dart';
// import 'package:newmanager/trash/product_model.dart';
// import 'package:newmanager/controller/cart_controllerw.dart';

// class ProductController extends GetxController {
//   final RxBool isLoading = true.obs;
//   final RxInt currentImageIndex = 0.obs;
//   final RxString selectedSize = ''.obs;
//   final RxString selectedColor = 'Gray'.obs;
//   final RxInt quantity = 1.obs;
//   final RxBool isFavorite = false.obs;

//   late Rx<Product> product;

//   @override
//   void onInit() {
//     super.onInit();
//     loadProduct();
//   }

//   void loadProduct() {
//     isLoading.value = true;

//     // If a product was passed via Get.arguments, use it; otherwise use simulated data
//     final arg = Get.arguments;
//     if (arg != null && arg is Product) {
//       product = arg.obs;
//       // ensure defaults
//       if (product.value.sizes.isEmpty)
//         product.value.sizes.addAll(['S', 'M', 'L']);
//       isLoading.value = false;
//       return;
//     }

//     // Simulated product data from SHEIN
//     product =
//         Product(
//           id: '91546664',
//           title:
//               "Men's Solid Color Long Sleeve Casual Versatile Zip-Up Stand Collar Sweater",
//           description:
//               'For Fall Winter\n\nThis comfortable and versatile sweater features a classic zip-up design with a stand collar, perfect for layering during fall and winter seasons. Made from quality fabric for durability and warmth.',
//           price: 28.99,
//           originalPrice: 45.99,
//           rating: 4.5,
//           reviews: 1247,
//           stock: 15,
//           color: 'Gray',
//           sizes: ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
//           images: [
//             'https://img.ltwebstatic.com/v4/j/spmp/2025/07/31/c0/1753943840b36d3621ffd74014d8a7f146ca46bc02_thumbnail_750x999.webp',
//             'https://img.ltwebstatic.com/v4/j/spmp/2025/07/31/c0/1753943840b36d3621ffd74014d8a7f146ca46bc02_thumbnail_750x999.webp',
//           ],
//           colors: ['Gray', 'Black', 'Navy', 'Brown', 'Khaki'],
//           quantity: 1,
//         ).obs;

//     Future.delayed(const Duration(milliseconds: 800), () {
//       isLoading.value = false;
//     });
//   }

//   void nextImage() {
//     if (currentImageIndex.value < product.value.images.length - 1) {
//       currentImageIndex.value++;
//     }
//   }

//   void previousImage() {
//     if (currentImageIndex.value > 0) {
//       currentImageIndex.value--;
//     }
//   }

//   void selectImage(int index) {
//     currentImageIndex.value = index;
//   }

//   void changeSize(String size) {
//     selectedSize.value = size;
//   }

//   void changeColor(String color) {
//     selectedColor.value = color;
//   }

//   void increaseQuantity() {
//     if (quantity.value < product.value.stock) {
//       quantity.value++;
//     }
//   }

//   void decreaseQuantity() {
//     if (quantity.value > 1) {
//       quantity.value--;
//     }
//   }

//   void toggleFavorite() {
//     isFavorite.value = !isFavorite.value;
//   }

//   void addToCart({
//     required String id,
//     required List<String> img,
//     required String title,
//     required double price,
//   }) {
//     if (selectedSize.isEmpty) {
//       Get.snackbar('Error', 'Please select a size');
//       return;
//     }
//     // Convert product to cart model and add to cart controller
//     final CartController cartController = Get.put(CartController());

//     final cartItem = Product(
//       id: ids,
//       title: title,
//       images: img,
//       originalPrice: product.value.originalPrice,
//       description: product.value.description,
//       price: price,
//       sizes:
//           product.value.sizes.isNotEmpty
//               ? [product.value.sizes[currentImageIndex.value]]
//               : [],
//       color: selectedColor.value,
//       rating: product.value.rating,
//       reviews: product.value.reviews,
//       stock: product.value.stock,
//       colors: product.value.colors,
//       quantity: quantity.value,
//     );
//     print('Adding to cart: ${cartItem.toJson()}');
//     // If same product (id + size + color) exists in cart, increase quantity
//     final existingIndex = cartController.products.indexWhere(
//       (p) =>
//           p.id == cartItem.id &&
//           p.sizes == cartItem.sizes &&
//           p.color == cartItem.color,
//     );

//     if (existingIndex >= 0) {
//       final existing = cartController.products[existingIndex];
//       existing.quantity += cartItem.quantity;
//       cartController.products.refresh();
//       Get.snackbar('Success', 'Updated quantity in cart');
//     } else {
//       cartController.products.add(cartItem);
//       Get.snackbar('Success', 'Added ${quantity.value} item(s) to cart');
//     }
//   }

//   void buyNow() {
//     if (selectedSize.isEmpty) {
//       Get.snackbar('Error', 'Please select a size');
//       return;
//     }
//     Get.snackbar('Purchase', 'Proceeding to checkout...');
//   }
// }
