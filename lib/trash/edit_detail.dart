// import 'package:get/get.dart';
// import 'package:newmanager/widget/detail_button.dart';
// import 'package:newmanager/widget/input_in_inputwidget.dart';
// import 'updat_pro_detail_controller.dart';

// class DetailPage extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const DetailPage({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     // Initialize the controller once here
//     DetailController controller = Get.put(DetailController());

//     final imageUrl =
//         data['product_image'] ??
//         'https://icons.veryicon.com/png/o/education-technology/alibaba-cloud-iot-business-department/image-load-failed.png';

//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(title: const Text('صفحة التفاصيل')),
//       body: SingleChildScrollView(
//         child: Center(
//           child: GetBuilder<DetailController>(
//             init: controller,
//             builder:
//                 (controller) => Column(
//                   children: [
//                     Image.network(
//                       imageUrl,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return const CircularProgressIndicator();
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.network(
//                           'https://cdn.iconscout.com/icon/premium/png-256-thumb/broken-15-85706.png',
//                           fit: BoxFit.contain,
//                         );
//                       },
//                       width: 500,
//                       height: 300,
//                       fit: BoxFit.fitWidth,
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.toggleH();
//                           },
//                           child: Text(
//                             'السعر: ${data['product_price'] ?? 'غير متوفر'}',
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.data = data['product_name'];
//                           },
//                           child: Text('الاسم: ${data['product_name']}'),
//                         ),
//                       ],
//                     ),
//                     controller.h
//                         ? Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 children: [
//                                   InputInInputWidget(
//                                     mycontroller: controller.nameController,
//                                     // استدعاء الويدجت الجديد
//                                     lText: 'الاسم',
//                                   ),
//                                   const SizedBox(height: 10),
//                                   InputInInputWidget(
//                                     lText: "السعر",
//                                     mycontroller: controller.priceController,
//                                   ),
//                                   const SizedBox(height: 10),

//                                   InputInInputWidget(
//                                     // استدعاء الويدجت الجديد
//                                     lText: ' رابط الصوره',
//                                     mycontroller: controller.imageController,
//                                   ),
//                                 ],
//                               ),

//                               Column(
//                                 children: [
//                                   DetailButton(
//                                     data: data,
//                                     proId: "${data['product_id']}",
//                                     controller: controller,
//                                     buttonText: 'حفظ',
//                                     bColor: Colors.green,
//                                   ),
//                                   SizedBox(height: 30),
//                                   DetailButton(
//                                     data: {},
//                                     proId: "${data['product_id']}",

//                                     controller: controller,
//                                     buttonText: 'الغاء',
//                                     bColor: Colors.red,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         )
//                         : const Text('...'),
//                   ],
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
// }
