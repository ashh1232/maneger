// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:maneger/core/constants/api_constants.dart';
// import 'package:maneger/features/products/presentation/controllers/product_detail_controller.dart';

// class ProductDetailView extends StatelessWidget {
//   final Object? manualProduct;

//   const ProductDetailView({super.key, this.manualProduct});

//   @override
//   Widget build(BuildContext context) {
//     // Inject Controller
//     final ProductDetailController controller = Get.put(
//       ProductDetailController(),
//     );

//     // Set manual product if provided
//     if (manualProduct != null) {
//       controller.setProduct(manualProduct);
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border, color: Colors.black),
//             onPressed: () {
//               Get.snackbar('Coming Soon', 'Favorites not available yet');
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.product.value == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final product = controller.product.value!;

//         return Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Image
//                     Hero(
//                       tag: product.id,
//                       child: Container(
//                         height: 350,
//                         width: double.infinity,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFF5F5F5),
//                         ),
//                         child: CachedNetworkImage(
//                           imageUrl: product.imageUrl.startsWith('http')
//                               ? product.imageUrl
//                               : "${ApiConstants.productsImages}/${product.imageUrl}",
//                           fit: BoxFit.cover,
//                           errorWidget: (context, url, error) => const Icon(
//                             Icons.image_not_supported,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                           placeholder: (context, url) =>
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   product.title,
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '\$${product.displayPrice}',
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   if (product.originalPrice > product.price)
//                                     Text(
//                                       '\$${product.displayOriginalPrice}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.grey,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),

//                           // Rating (Mock)
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star,
//                                       color: Colors.white,
//                                       size: 16,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       '4.8',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               const Text(
//                                 'Reviews',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),

//                           // Description
//                           const Text(
//                             'Description',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             product.description,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                               height: 1.5,
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           // Quantity
//                           Row(
//                             children: [
//                               const Text(
//                                 'Quantity',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey[300]!),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.remove),
//                                       onPressed: controller.decreaseQuantity,
//                                     ),
//                                     Obx(
//                                       () => Text(
//                                         '${controller.quantity.value}',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.add),
//                                       onPressed: controller.increaseQuantity,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Bottom Add to Cart Button
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       controller.addToCart();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Add to Cart',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
