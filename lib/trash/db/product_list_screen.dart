// // lib/product_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/db/add_product_screen.dart';

// import 'test_product_controller.dart';

// class ProductListScreen extends StatelessWidget {
//   const ProductListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Find the already initialized controller`
//     final TalabatProductController pc = Get.find();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Firebase Products (GetX)')),
//       body: Obx(() {
//         // Use Obx to react to changes in pc.productList
//         if (pc.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (pc.productList.isEmpty) {
//           return const Center(child: Text('No products found.'));
//         }

//         return ListView.builder(
//           itemCount: pc.productList.length,
//           itemBuilder: (context, index) {
//             final product = pc.productList[index];
//             return ListTile(
//               leading: Text('${product.title}'),
//               title: Text(product.image),
//               subtitle: Text('Quantity: ${product.quantity}'),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Use Get.to() for navigation
//           Get.to(() => const AddProductScreen())?.then((value) {
//             // Optional: Refetch or ensure UI updates when returning
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
