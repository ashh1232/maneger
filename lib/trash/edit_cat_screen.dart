// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/class/handlingdataview.dart';
// import 'package:newmanager/trash/testcontroller.dart';
// import 'package:newmanager/routes.dart';
// import 'package:newmanager/trash/editDetail.dart';
// import 'package:newmanager/widget/cat_list.dart';
// import '../widget/edit_pro_card.dart';

// class CatScreen extends StatelessWidget {
//   CatScreen({super.key});
//   final TestController testController = Get.find<TestController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       backgroundColor: Colors.grey.shade300,
//       body: GetBuilder<TestController>(
//         builder:
//             (controller) => Column(
//               children: [
//                 SizedBox(
//                   height: 40,
//                   child: ListView.builder(
//                     //main category list
//                     scrollDirection: Axis.horizontal,
//                     itemCount: controller.mcat.length + 1,
//                     itemBuilder: (x, s) {
//                       if (s == 0) {
//                         return CatList(
//                           testController: testController,
//                           b: s,
//                           title: 'الكل',
//                           color: controller.currentMainSel == s,
//                           fanc: () {
//                             controller.mCatSel(0, s);
//                           },
//                         );
//                       } else {
//                         return CatList(
//                           testController: testController,
//                           b: s,
//                           title: controller.mcat[s - 1]['m_cat_name'],
//                           color: controller.currentMainSel == s,
//                           fanc: () {
//                             controller.mCatSel(
//                               controller.mcat[s - 1]['m_cat_id'],
//                               s,
//                             );
//                           },
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         //product list
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 100,
//                               width: 100,
//                               //////////// add button
//                               child: GestureDetector(
//                                 onTap: () => controller.gotoAdd(),
//                                 child: Card(
//                                   child: const Icon(
//                                     Icons.add_outlined,
//                                     color: Color.fromARGB(255, 116, 116, 116),
//                                     size: 36.0,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: GetBuilder<TestController>(
//                                 builder: (controller) {
//                                   return Handlingdataview(
//                                     statusRequest: controller.statusRequest,
//                                     widget: Container(
//                                       padding: EdgeInsets.only(top: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[300],
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.grey.shade300,
//                                             Colors.grey.shade400,
//                                           ],
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                         ),
//                                       ),

//                                       child: GridView.builder(
//                                         padding: EdgeInsets.all(9),
//                                         gridDelegate:
//                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 2,
//                                               crossAxisSpacing: 8,
//                                               mainAxisSpacing: 12,
//                                               childAspectRatio: 0.75,
//                                             ),
//                                         itemCount: controller.proCat.length,
//                                         itemBuilder: (context, index) {
//                                           return InkWell(
//                                             onTap:
//                                                 () => Get.toNamed(
//                                                   AppRoutes.productDetail,
//                                                   // arguments: productController.products[index],
//                                                 ),
//                                             child: InkWell(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder:
//                                                         (context) => DetailPage(
//                                                           data:
//                                                               controller
//                                                                   .proCat[index],
//                                                         ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: HomeCard(
//                                                 index: index,
//                                                 img:
//                                                     controller
//                                                         .proCat[index]['product_image'],
//                                                 title:
//                                                     controller
//                                                         .proCat[index]['product_name'],
//                                                 price:
//                                                     controller
//                                                         .proCat[index]['product_price'],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 100,

//                         child: ListView.builder(
//                           //category list
//                           itemCount: testController.scat.length,
//                           itemBuilder:
//                               (d, b) => CatList(
//                                 testController: testController,
//                                 b: b,
//                                 title:
//                                     testController.scat[b]['categories_name'],
//                                 color: testController.currentsCat == b,
//                                 fanc: () {
//                                   testController.sCatSel(
//                                     testController.scat[b]['categories_id'],
//                                     b,
//                                   );
//                                 },
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//       ),
//     );
//   }
// }
