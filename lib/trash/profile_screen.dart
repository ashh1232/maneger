// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/user_page_controller.dart';

// class UserPage extends StatelessWidget {
//   final UserPageController userPageController = Get.put(UserPageController());

//   UserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Container(
//                 color: Colors.blue,
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'تسجيل الدخول/انشاء حساب',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.symmetric(vertical: 16.0),
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.amber.shade100,
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: 250,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'DOCANA CLUB',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8.0),
//                                 Text(
//                                   'مركز علمي في الصناعة و التقنية والأعمال الإبداعية للمجتمع',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Text('join us'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildIconWithLabel(Icons.badge, 'كوبون'),
//                         _buildIconWithLabel(Icons.monetization_on, 'نقاط'),
//                         _buildIconWithLabel(
//                           Icons.account_balance_wallet,
//                           'محفظه',
//                         ),
//                         _buildIconWithLabel(Icons.redeem, 'بطاقه هديه'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 16.0),
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.amber.shade100,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'مركز علمي في الصناعة و التقنية والأعمال',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           color: Colors.black,
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             'take it',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         IconButton(icon: Icon(Icons.close), onPressed: () {}),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 16.0),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'طلبي',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildIconWithLabel(Icons.badge, 'كوبون'),
//                         _buildIconWithLabel(
//                           Icons.precision_manufacturing,
//                           'قيد التجهيز',
//                         ),
//                         _buildIconWithLabel(Icons.local_shipping, 'تم الشحن'),
//                         _buildIconWithLabel(Icons.sms, 'تعليق'),
//                         _buildIconWithLabel(Icons.menu, 'النتجات المسترجعه'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 16.0),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'المزيد من الخدمات',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildIconWithLabel(Icons.support_agent, 'دعم'),
//                         _buildIconWithLabel(Icons.receipt_long, 'استطلاع'),
//                         _buildIconWithLabel(
//                           Icons.account_balance_wallet,
//                           'محفظه',
//                         ),
//                         _buildIconWithLabel(Icons.check_box, 'متابع'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 16.0),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildTab('قائمه الاماني', true),
//                         _buildTab('شوهد مؤخرا', false),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'لم تقم بحفظ اي شيء مؤخرا',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     SizedBox(height: 16.0),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                         horizontal: 16.0,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Text('للتسوق'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIconWithLabel(IconData icon, String label) {
//     return Column(
//       children: [Icon(icon, size: 40), SizedBox(height: 8.0), Text(label)],
//     );
//   }

//   Widget _buildTab(String label, bool isActive) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//             fontSize: 16,
//           ),
//         ),
//         if (isActive)
//           Container(
//             margin: const EdgeInsets.only(top: 4.0),
//             height: 3.0,
//             width: 60.0,
//             color: Colors.black,
//           ),
//       ],
//     );
//   }
// }
