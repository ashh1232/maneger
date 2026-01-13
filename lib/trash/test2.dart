// // import 'package:flutter/material.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// // import 'package:get/get.dart';
// // import 'package:newmanager/controller/home_pro_controller.dart';
// // import 'package:newmanager/trash/product_card.dart';

// class AniAppbarScreenn2 extends StatelessWidget {
//   final controller = Get.put(ProductssController());

// <<<<<<< HEAD
//   AniAppbarScreenn2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<ProductssController>(
//         init: controller,
//         builder: (conta) {
//           return NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification notif) {
//               if (notif.metrics.pixels > 50) {
//                 if (!controller.isScrolled) controller.asd(true);
//               } else {
//                 if (controller.isScrolled) controller.asd(false);
//               }
//               return true;
//             },
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   pinned: true,
//                   expandedHeight: 260,
//                   backgroundColor: Colors.white,
//                   elevation: 0,
//                   title: SizedBox(height: 42, child: buildSearchBar()),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: buildCarouselBanner(),
//                   ),
//                 ),
// =======
//   const AniAppbarScreenn2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<ProductssController>(
//         init: controller,
//         builder: (conta) {
//           return NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification notif) {
//               if (notif.metrics.pixels > 50) {
//                 if (!controller.isScrolled) controller.asd(true);
//               } else {
//                 if (controller.isScrolled) controller.asd(false);
//               }
//               return true;
//             },
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   pinned: true,
//                   expandedHeight: 260,
//                   backgroundColor: Colors.white,
//                   elevation: 0,
//                   title: SizedBox(height: 42, child: buildSearchBar()),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: buildCarouselBanner(),
//                   ),
//                 ),
// =======
// //   const AniAppbarScreenn2({super.key});
// >>>>>>> ba93ef8 (work)

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: GetBuilder<ProductssController>(
// //         init: controller,
// //         builder: (conta) {
// //           return NotificationListener<ScrollNotification>(
// //             onNotification: (ScrollNotification notif) {
// //               if (notif.metrics.pixels > 50) {
// //                 if (!controller.isScrolled) controller.asd(true);
// //               } else {
// //                 if (controller.isScrolled) controller.asd(false);
// //               }
// //               return true;
// //             },
// //             child: CustomScrollView(
// //               slivers: [
// //                 SliverAppBar(
// //                   pinned: true,
// //                   expandedHeight: 260,
// //                   backgroundColor: Colors.white,
// //                   elevation: 0,
// //                   title: SizedBox(height: 42, child: buildSearchBar()),
// //                   flexibleSpace: FlexibleSpaceBar(
// //                     background: buildCarouselBanner(),
// //                   ),
// //                 ),

// //                 // Quick actions row
// //                 SliverToBoxAdapter(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12.0,
// //                       vertical: 10,
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         quickAction(Icons.local_shipping, 'شحن'),
// //                         quickAction(Icons.percent, 'عروض'),
// //                         quickAction(Icons.support_agent, 'خدمة'),
// //                         quickAction(Icons.location_on, 'فروع'),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 // Categories chips
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     height: 70,
// //                     padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
// //                     child: ListView(
// //                       scrollDirection: Axis.horizontal,
// //                       children: [
// //                         SizedBox(width: 6),
// //                         categoryChip('الكل', true),
// //                         categoryChip('رجالي'),
// //                         categoryChip('نسائي'),
// //                         categoryChip('أطفال'),
// //                         categoryChip('إلكترونيات'),
// //                         categoryChip('أحذية'),
// //                         SizedBox(width: 6),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 // Featured horizontal list header
// //                 SliverToBoxAdapter(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12.0,
// //                       vertical: 8,
// //                     ),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           'مستحسن',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         TextButton(onPressed: () {}, child: Text('عرض الكل')),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //                 // Featured horizontal products
// //                 SliverToBoxAdapter(
// //                   child: SizedBox(
// //                     height: 260,
// //                     child: ListView.separated(
// //                       padding: EdgeInsets.symmetric(horizontal: 12),
// //                       scrollDirection: Axis.horizontal,
// //                       itemBuilder: (context, index) {
// //                         final p =
// //                             controller.products[index %
// //                                 controller.products.length];
// //                         return GestureDetector(
// //                           onTap: () => Get.toNamed('/detail'),
// //                           child: SizedBox(
// //                             width: 180,
// //                             child: ProductCard(
// //                               index: index,
// //                               img: 'p.img[0]',
// //                               title: p.title,
// //                               price: 1,
// //                               //  "p.price",
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                       separatorBuilder: (_, __) => SizedBox(width: 12),
// //                       itemCount:
// //                           controller.products.length > 6
// //                               ? 6
// //                               : controller.products.length,
// //                     ),
// //                   ),
// //                 ),

// //                 // Grid / masonry for the rest of products
// //                 SliverPadding(
// //                   padding: EdgeInsets.all(12),
// //                   sliver: SliverMasonryGrid.count(
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 12,
// //                     mainAxisSpacing: 12,
// //                     childCount: controller.products.length,
// //                     itemBuilder: (context, index) {
// //                       return InkWell(
// //                         onTap: () => Get.toNamed('/detail'),
// //                         child: ProductCard(
// //                           index: index,
// //                           img: 'controller.products[index].img[0]',
// //                           title: controller.products[index].title,
// //                           price: 5,
// //                           // controller.products[index].price,
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget buildCarouselBanner() {
// //     final banners = [
// //       'http://10.0.2.2/img/image1.jpg',
// //       'http://10.0.2.2/img/image1.jpg',
// //       'http://10.0.2.2/img/image1.jpg',
// //     ];

// <<<<<<< HEAD
//   Widget buildSearchBar() {
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 8),
//           child: Icon(Icons.menu, color: Colors.black54),
//         ),
//         Expanded(
//           child: Container(
//             height: 42,
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 6,
//                   // ignore: deprecated_member_use
//                   color: Colors.black.withOpacity(0.08),
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'ملابس رجالي و ستاتي',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Icon(Icons.favorite_border, color: Colors.black54),
//       ],
//     );
//   }
// =======
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 8),
//           child: Icon(Icons.menu, color: Colors.black54),
//         ),
//         Expanded(
//           child: Container(
//             height: 42,
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 6,
//                   // ignore: deprecated_member_use
//                   color: Colors.black.withOpacity(0.08),
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'ملابس رجالي و ستاتي',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Icon(Icons.favorite_border, color: Colors.black54),
//       ],
//     );
//   }
// =======
// //     return Stack(
// //       fit: StackFit.expand,
// //       children: [
// //         PageView.builder(
//           itemCount: banners.length,
//           itemBuilder:
//               (context, i) => Image.network(banners[i], fit: BoxFit.cover),
//         ),
//         Container(color: Colors.black26),
//       ],
//     );
//   }
// >>>>>>> ba93ef8 (work)

//   Widget buildSearchBar() {
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 8),
//           child: Icon(Icons.menu, color: Colors.black54),
//         ),
//         Expanded(
//           child: Container(
//             height: 42,
//             margin: EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 6,
//                   // ignore: deprecated_member_use
//                   color: Colors.black.withOpacity(0.08),
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 SizedBox(width: 12),
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'ملابس رجالي و ستاتي',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Icon(Icons.favorite_border, color: Colors.black54),
//       ],
//     );
//   }
// =======
// //     return Stack(
// //       fit: StackFit.expand,
// //       children: [
// //         PageView.builder(
// //           itemCount: banners.length,
// //           itemBuilder:
// //               (context, i) => Image.network(banners[i], fit: BoxFit.cover),
// //         ),
// //         Container(color: Colors.black26),
// //       ],
// //     );
// //   }
// >>>>>>> ba93ef8 (work)

// //   Widget buildSearchBar() {
// //     return Row(
// //       children: [
// //         Padding(
// //           padding: EdgeInsets.only(left: 8),
// //           child: Icon(Icons.menu, color: Colors.black54),
// //         ),
// //         Expanded(
// //           child: Container(
// //             height: 42,
// //             margin: EdgeInsets.symmetric(horizontal: 8),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(30),
// //               boxShadow: [
// //                 BoxShadow(
// //                   blurRadius: 6,
// //                   color: Colors.black.withOpacity(0.08),
// //                   offset: Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               children: [
// //                 SizedBox(width: 12),
// //                 Icon(Icons.search, color: Colors.grey),
// //                 SizedBox(width: 8),
// //                 Expanded(
// //                   child: Text(
// //                     'ملابس رجالي و ستاتي',
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 10),
// //                   child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         Icon(Icons.favorite_border, color: Colors.black54),
// //       ],
// //     );
// //   }

// //   Widget categoryChip(String title, [bool selected = false]) {
// //     return Padding(
// //       padding: const EdgeInsets.only(right: 8.0),
// //       child: ChoiceChip(
// //         label: Text(
// //           title,
// //           style: TextStyle(color: selected ? Colors.white : Colors.black87),
// //         ),
// //         selected: selected,
// //         onSelected: (_) {},
// //         selectedColor: Colors.purple,
// //         backgroundColor: Colors.white,
// //         elevation: 2,
// //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       ),
// //     );
// //   }

// //   Widget quickAction(IconData icon, String label) {
// //     return Column(
// //       children: [
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
// //           ),
// //           padding: EdgeInsets.all(10),
// //           child: Icon(icon, color: Colors.purple),
// //         ),
// //         SizedBox(height: 6),
// //         Text(label, style: TextStyle(fontSize: 12)),
// //       ],
// //     );
// //   }
// // }
