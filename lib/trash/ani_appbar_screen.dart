// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/controller/home_pro_controller.dart';
// import 'package:newmanager/trash/ani_appbar_controller.dart';
// import 'package:newmanager/routes.dart';
// import 'package:newmanager/widget/product_card.dart';

// class AniAppbarScreen extends StatelessWidget {
//   const AniAppbarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AniAppbarController controller = Get.put(AniAppbarController());

//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.purple),
//               child: Text(
//                 'Navigation',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('addscreen'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Get.toNamed(AppRoutes.addscreen);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.shopping_bag),
//               title: Text('Products'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Get.toNamed(AppRoutes.discover);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.shopping_bag),
//               title: Text('firebasePro'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Get.toNamed(AppRoutes.firbasePro);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Get.toNamed(AppRoutes.profile);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('mail'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Get.toNamed(AppRoutes.mail);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: GetBuilder<ProductssController>(
//         init: Get.put(ProductssController()),
//         builder: (productController) {
//           return NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification notif) {
//               if (notif.metrics.pixels > 50) {
//                 if (!controller.isScrolled.value) controller.toggleScroll(true);
//               } else {
//                 if (controller.isScrolled.value) controller.toggleScroll(false);
//               }
//               return true;
//             },
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   pinned: true,
//                   floating: false,
//                   expandedHeight: 220,
//                   backgroundColor: Colors.white,
//                   elevation: 0,
//                   title: SizedBox(
//                     height: 36,
//                     child: _buildSearchBar(controller, productController),
//                   ),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: _buildCarouselBanner(controller),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 7),
//                     height: 100,
//                     color: Colors.grey.shade100,
//                     child: _buildCobon(),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     height: 220,
//                     color: Colors.grey.shade100,
//                     child: Center(
//                       child: GridView.builder(
//                         scrollDirection: Axis.horizontal,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                         ),
//                         itemCount: productController.products.length,
//                         itemBuilder:
//                             (context, index) => HomeCatItems(
//                               img: productController.products[index].images[0],
//                               title: productController.products[index].title,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SliverPadding(
//                   padding: EdgeInsets.all(10),
//                   sliver: SliverMasonryGrid.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                     childCount: productController.products.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap:
//                             () => Get.toNamed(
//                               AppRoutes.productDetail,
//                               arguments: productController.products[index],
//                             ),
//                         child: ProductCard(
//                           index: index,
//                           img: productController.products[index].images[0],
//                           title: productController.products[index].title,
//                           price:
//                               productController.products[index].price.toInt(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCarouselBanner(AniAppbarController controller) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         NotificationListener<ScrollNotification>(
//           onNotification: (n) => true,
//           child: PageView.builder(
//             controller: controller.pageController,
//             itemCount: controller.banners.length,
//             onPageChanged: (i) => controller.setBannerIndex(i),
//             itemBuilder:
//                 (context, i) => Image.network(
//                   controller.banners[i],
//                   fit: BoxFit.fill,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       color: Colors.black12,
//                       child: Center(
//                         child: SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             value:
//                                 loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         (loadingProgress.expectedTotalBytes ??
//                                             1)
//                                     : null,
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   errorBuilder:
//                       (context, error, stackTrace) => Container(
//                         color: Colors.grey.shade300,
//                         child: Center(
//                           child: Icon(
//                             Icons.broken_image,
//                             color: Colors.white70,
//                             size: 48,
//                           ),
//                         ),
//                       ),
//                 ),
//           ),
//         ),
//         Container(color: Colors.black26),
//         Positioned(
//           left: 0,
//           right: 0,
//           bottom: 12,
//           child: Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 controller.banners.length,
//                 (i) => AnimatedContainer(
//                   duration: Duration(milliseconds: 250),
//                   margin: EdgeInsets.symmetric(horizontal: 4),
//                   width: controller.currentBannerIndex.value == i ? 18 : 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color:
//                         controller.currentBannerIndex.value == i
//                             ? Colors.white
//                             : Colors.white54,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCobon() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.pink[50],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'عروض حصرية ',

//                           style: TextStyle(
//                             color: Colors.purple,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Icon(Icons.flash_on, color: Colors.purple, size: 20),
//                       ],
//                     ),
//                     Text(
//                       'شاهد العروض الحصرية الان',
//                       style: TextStyle(color: Colors.grey, fontSize: 10),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(height: 40, width: 1, color: Colors.pink[200]),
//           Expanded(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'توصيل مجاني',
//                       style: TextStyle(
//                         color: Colors.purple,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Icon(Icons.local_shipping, color: Colors.purple, size: 20),
//                   ],
//                 ),
//                 Text(
//                   'اشترى ب 114.00\$ اكثر لتحصل علي',
//                   style: TextStyle(color: Colors.purple[300], fontSize: 10),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar(
//     AniAppbarController controller,
//     ProductssController productController,
//   ) {
//     return Obx(
//       () => Row(
//         children: [
//           Expanded(
//             child:
//                 controller.isScrolled.value
//                     ? Center(
//                       child: Text(
//                         'SHEIN',
//                         style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 8.5,
//                         ),
//                       ),
//                     )
//                     : Container(
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 6,
//                             color: Colors.black.withOpacity(0.08),
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10),
//                           Icon(Icons.camera_alt_outlined, size: 22),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'ملابس رجالي و ستاتي',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                             child: Icon(Icons.search, size: 22),
//                           ),
//                           Container(
//                             width: 1,
//                             height: 20,
//                             color: Colors.grey.shade300,
//                           ),
//                         ],
//                       ),
//                     ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Icon(
//               Icons.favorite_border,
//               size: 22,
//               color: controller.isScrolled.value ? Colors.black : Colors.white,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 12),
//             child: InkWell(
//               onTap: () => Get.toNamed(AppRoutes.cartPage),
//               child: Icon(
//                 Icons.shopping_cart_checkout_sharp,
//                 size: 22,
//                 color:
//                     controller.isScrolled.value ? Colors.black : Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomeCatItems extends StatelessWidget {
//   const HomeCatItems({super.key, required this.title, required this.img});
//   final String title;
//   final String img;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Get.toNamed(AppRoutes.category),
//       child: Column(
//         children: [
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.all(9),
//               height: 30,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(img),
//                   fit: BoxFit.cover,
//                 ),
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 6,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Text(title, style: TextStyle(fontSize: 10)),
//         ],
//       ),
//     );
//   }
// }
