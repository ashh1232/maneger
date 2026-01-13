// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/controller/add_controller.dart';
// import 'package:newmanager/widget/input_in_inputwidget.dart';

// class AddScreen extends StatelessWidget {
//   const AddScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AddController controsller = Get.put(AddController());
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         title: Text('Add new product'),
//         backgroundColor: Colors.grey.shade400,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,

//             children: [
//               InputInInputWidget(
//                 lText: 'الاسم',
//                 mycontroller: controsller.nameController,
//               ),
//               SizedBox(height: 20),
//               InputInInputWidget(
//                 lText: 'السعر',
//                 mycontroller: controsller.priceController,
//               ),
//               SizedBox(height: 20),
//               InputInInputWidget(
//                 lText: 'رابط الصوره',
//                 mycontroller: controsller.imageController,
//               ),
//               SizedBox(height: 30),

//               SizedBox(height: 30),
//               RadioListTile(
//                 toggleable: true,
//                 title: Text('ffff'),
//                 controlAffinity: ListTileControlAffinity.trailing,
//                 selectedTileColor: Colors.blue,
//                 activeColor: Colors.amber,
//                 value: 'klj',
//                 groupValue: 5,
//                 onChanged: (value) => print(value),
//               ),

//               SizedBox(
//                 height: 50,

//                 child: GetBuilder<AddController>(
//                   builder:
//                       (s) => ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: controsller.testControsller.cat.length,
//                         itemBuilder:
//                             (context, index) => Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: InkWell(
//                                 onTap: () {
//                                   String id =
//                                       "  ${controsller.testControsller.cat[index]['categories_id']}";
//                                   controsller.selCattt(index, id);
//                                 },
//                                 child: Container(
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                     border: Border(bottom: BorderSide()),
//                                     borderRadius: BorderRadius.circular(15),
//                                     color:
//                                         controsller.curent == index
//                                             ? Colors.amber
//                                             : const Color.fromARGB(28, 0, 0, 0),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       controsller
//                                           .testControsller
//                                           .cat[index]['categories_name'],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   controsller.addNewData();
//                 },

//                 child: Text('add'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
