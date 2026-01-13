// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'cart_controller.dart';

// class CartView extends StatelessWidget {
//   CartView({super.key});

//   final CartController cartController = Get.put(CartController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cart')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Obx(() {
//           if (cartController.cart.isEmpty) {
//             return Center(
//               child: Text(
//                 'سلتك فارغه',
//                 style: TextStyle(
//                   fontFamily: 'Noto Nastaliq Urdu',
//                   fontSize: 60,
//                 ),
//               ),
//             );
//           } else {
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartController.cart.length,
//                     itemBuilder: (context, index) {
//                       final item = cartController.cart[index];
//                       return Card(
//                         child: ListTile(
//                           leading: GestureDetector(
//                             onTap: () {
//                               // Navigate to product detail
//                             },
//                             child: Image.network(item.productImage),
//                           ),
//                           title: Text(item.productName),
//                           subtitle: Text(
//                             '${item.productPrice * item.productCount} ₪',
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.remove),
//                                 onPressed:
//                                     () => cartController.removeFromCart(item),
//                               ),
//                               Text('${item.productCount}'),
//                               IconButton(
//                                 icon: const Icon(Icons.add),
//                                 onPressed: () => cartController.addToCart(item),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.close),
//                                 onPressed:
//                                     () => cartController.removeItem(item),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('المجموع الفرعي'),
//                             Obx(
//                               () => Text('${cartController.subtotal.value} ₪'),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('رسوم التوصيل'),
//                             Obx(
//                               () =>
//                                   Text('${cartController.deliveryFee.value} ₪'),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('المجموع'),
//                             Obx(() => Text('${cartController.total.value} ₪')),
//                           ],
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             // Show order confirmation dialog
//                           },
//                           child: const Text('تأكيد الطلب'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         }),
//       ),
//     );
//   }
// }
