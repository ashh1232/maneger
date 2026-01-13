// // lib/views/product_detail_view.dart
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/controller/product_controller.dart';
// import 'package:newmanager/trash/product_model.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class ProductDetailView extends GetView<ProductController> {
//   ProductDetailView({Key? key}) : super(key: key);
//   final pro = Get.arguments as Product;
//   @override
//   Widget build(BuildContext context) {
//     final ProductController controller = Get.put(ProductController());

//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('تحميل المنتج ...'),
//               ],
//             ),
//           );
//         }

//         return CustomScrollView(
//           slivers: [
//             // App Bar
//             SliverAppBar(
//               expandedHeight: 50,
//               backgroundColor: Colors.white,
//               elevation: 0.5,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Colors.black),
//                 onPressed: () => Get.back(),
//               ),
//               actions: [
//                 IconButton(
//                   icon: Obx(
//                     () => Icon(
//                       controller.isFavorite.value
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                       color:
//                           controller.isFavorite.value
//                               ? Colors.red
//                               : Colors.black,
//                     ),
//                   ),
//                   onPressed: controller.toggleFavorite,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.share, color: Colors.black),
//                   onPressed: () => Get.snackbar('Share', 'Sharing product...'),
//                 ),
//               ],
//             ),
//             // Product Images Section
//             SliverToBoxAdapter(child: _buildImageSection()),
//             // Product Details Section
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildPriceSection(),
//                     SizedBox(height: 16),
//                     _buildRatingSection(),
//                     SizedBox(height: 16),
//                     _buildTitleSection(),
//                     SizedBox(height: 16),
//                     _buildActionButtons(),
//                     SizedBox(height: 24),
//                     _buildColorSection(),
//                     SizedBox(height: 16),
//                     _buildSizeSection(),
//                     SizedBox(height: 16),
//                     _buildQuantitySection(),
//                     SizedBox(height: 16),
//                     _buildStockSection(),

//                     SizedBox(height: 24),
//                     _buildDescriptionSection(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   Widget _buildImageSection() {
//     return Column(
//       children: [
//         Container(
//           color: Color(0xFFF5F5F5),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 400,
//                 child: Stack(
//                   children: [
//                     PageView.builder(
//                       onPageChanged: (index) => controller.selectImage(index),
//                       itemCount: pro.images.length,
//                       itemBuilder: (context, index) {
//                         return CachedNetworkImage(
//                           imageUrl: pro.images[index],
//                           fit: BoxFit.cover,
//                           placeholder:
//                               (context, url) =>
//                                   Center(child: CircularProgressIndicator()),
//                           errorWidget:
//                               (context, url, error) => Icon(Icons.broken_image),
//                         );
//                       },
//                     ),
//                     Positioned(
//                       bottom: 16,
//                       left: 0,
//                       right: 0,
//                       child: Obx(
//                         () => Center(
//                           child: SmoothPageIndicator(
//                             controller: PageController(
//                               initialPage: controller.currentImageIndex.value,
//                             ),
//                             count: controller.product.value.images.length,
//                             effect: ScrollingDotsEffect(
//                               activeDotColor: Colors.white,
//                               dotColor: Colors.grey.shade400,
//                               dotHeight: 8,
//                               dotWidth: 8,
//                             ),
//                             onDotClicked:
//                                 (index) => controller.selectImage(index),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12),
//               SizedBox(
//                 height: 80,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: pro.images.length,
//                   itemBuilder: (context, index) {
//                     return Obx(
//                       () => GestureDetector(
//                         onTap: () => controller.selectImage(index),
//                         child: Container(
//                           margin: EdgeInsets.only(right: 8),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color:
//                                   controller.currentImageIndex.value == index
//                                       ? Colors.blue
//                                       : Colors.grey.shade300,
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: CachedNetworkImage(
//                               imageUrl: pro.images[index],
//                               fit: BoxFit.cover,
//                               width: 70,

//                               placeholder:
//                                   (context, url) => Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                               errorWidget:
//                                   (context, url, error) =>
//                                       Icon(Icons.broken_image),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 12),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPriceSection() {
//     return Row(
//       children: [
//         Obx(
//           () => Text(
//             '\$${controller.product.value.price.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         SizedBox(width: 12),
//         Obx(
//           () => Text(
//             '\$${controller.product.value.originalPrice.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey,
//               decoration: TextDecoration.lineThrough,
//             ),
//           ),
//         ),
//         Spacer(),
//         Obx(() {
//           double discount =
//               ((controller.product.value.originalPrice -
//                       controller.product.value.price) /
//                   controller.product.value.originalPrice *
//                   100);
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '-${discount.toStringAsFixed(0)}%',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildRatingSection() {
//     return Row(
//       children: [
//         Icon(Icons.star, color: Colors.amber, size: 20),
//         SizedBox(width: 4),
//         Obx(
//           () => Text(
//             '${controller.product.value.rating}',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(width: 8),
//         Obx(
//           () => Text(
//             '(${controller.product.value.reviews} reviews)',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTitleSection() {
//     return Obx(
//       () => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             controller.product.value.title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           //   SizedBox(height: 8),
//           //   Text(
//           //     controller.product.value.description,
//           //     style: TextStyle(color: Colors.grey, height: 1.5),
//           //   ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Color',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         SizedBox(height: 8),
//         Obx(
//           () => Wrap(
//             spacing: 8,
//             children:
//                 controller.product.value.colors.map((color) {
//                   return ChoiceChip(
//                     label: Text(color),
//                     selected: controller.selectedColor.value == color,
//                     onSelected: (selected) => controller.changeColor(color),
//                     backgroundColor: Colors.grey.shade200,
//                     selectedColor: Colors.blue,
//                     labelStyle: TextStyle(
//                       color:
//                           controller.selectedColor.value == color
//                               ? Colors.white
//                               : Colors.black,
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSizeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Size',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         SizedBox(height: 8),
//         Obx(
//           () => Wrap(
//             spacing: 8,
//             children:
//                 controller.product.value.sizes.map((size) {
//                   return ChoiceChip(
//                     label: Text(size),
//                     selected: controller.selectedSize.value == size,
//                     onSelected: (selected) => controller.changeSize(size),
//                     backgroundColor: Colors.grey.shade200,
//                     selectedColor: Colors.blue,
//                     labelStyle: TextStyle(
//                       color:
//                           controller.selectedSize.value == size
//                               ? Colors.white
//                               : Colors.black,
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantitySection() {
//     return Row(
//       children: [
//         Text(
//           'Quantity',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Spacer(),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.remove, size: 20),
//                 onPressed: controller.decreaseQuantity,
//                 constraints: BoxConstraints(minWidth: 36, minHeight: 36),
//               ),
//               Obx(
//                 () => Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     '${controller.quantity.value}',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.add, size: 20),
//                 onPressed: controller.increaseQuantity,
//                 constraints: BoxConstraints(minWidth: 36, minHeight: 36),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStockSection() {
//     return Obx(
//       () => Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color:
//               controller.product.value.stock > 5
//                   ? Colors.green.shade50
//                   : Colors.orange.shade50,
//           border: Border.all(
//             color:
//                 controller.product.value.stock > 5
//                     ? Colors.green.shade300
//                     : Colors.orange.shade300,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               controller.product.value.stock > 0
//                   ? Icons.check_circle
//                   : Icons.cancel,
//               color:
//                   controller.product.value.stock > 0
//                       ? Colors.green
//                       : Colors.red,
//             ),
//             SizedBox(width: 8),
//             Text(
//               controller.product.value.stock > 0
//                   ? 'In Stock (${controller.product.value.stock} available)'
//                   : 'Out of Stock',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed:
//                 () => {
//                   controller.addToCart(
//                     ids: pro.id,
//                     img: pro.images,
//                     title: pro.title,
//                     price: pro.price,
//                   ),
//                 },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             child: Text(
//               'اضف الى السله',
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ),
//         SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _buildDescriptionSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Product Details',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 16),
//         Obx(
//           () => Text(
//             controller.product.value.description,
//             style: TextStyle(color: Colors.grey.shade700, height: 1.6),
//           ),
//         ),
//         SizedBox(height: 16),
//         Text(
//           'Shipping Information',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'Free shipping on orders over \$50. Standard delivery takes 7-15 business days.',
//           style: TextStyle(color: Colors.grey.shade700, height: 1.6),
//         ),
//         SizedBox(height: 16),
//         Text(
//           'Return Policy',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text(
//           '30-day money-back guarantee. No questions asked returns.',
//           style: TextStyle(color: Colors.grey.shade700, height: 1.6),
//         ),
//       ],
//     );
//   }
// }
