// // lib/add_product_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/db/test_product_controller.dart';

// class AddProductScreen extends StatelessWidget {
//   const AddProductScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TalabatProductController pc = Get.find();
//     final TextEditingController _titleController = TextEditingController();
//     final TextEditingController _imgController = TextEditingController();
//     final TextEditingController _priceController = TextEditingController();
//     final TextEditingController _descriptionController =
//         TextEditingController();
//     final _formKey = GlobalKey<FormState>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Add New Product (GetX)')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product Title',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _imgController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product img',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a img.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product price',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a pric.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Product description',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description.';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     await pc.saveNewProduct(
//                       _titleController.text,
//                       _imgController.text,
//                       _descriptionController.text,
//                       int.parse(_priceController.text),
//                     );
//                     // Use Get.back() instead of Navigator.pop()
//                     Get.back();
//                   }
//                 },
//                 child: const Text('Save to Firebase'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
