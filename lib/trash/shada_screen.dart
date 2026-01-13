// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/shada_controller.dart';
//
// class ShadaPage extends StatelessWidget {
//   final ShadaController controller = Get.put(ShadaController());
//
//   ShadaPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Shada Page')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     onPressed: controller.newGameBtn,
//                     child: Text('New Game!'),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: controller.newGameBtn,
//                   ),
//                 ],
//               ),
//               Obx(() {
//                 return Column(
//                   children: [
//                     Table(
//                       border: TableBorder.all(),
//                       children: [
//                         TableRow(
//                           children: [
//                             TableCell(child: Center(child: Text('الدور'))),
//                             TableCell(child: Center(child: Text('Name 0'))),
//                             TableCell(child: Center(child: Text('Name 1'))),
//                             TableCell(child: Center(child: Text('Name 2'))),
//                             TableCell(child: Center(child: Text('Name 3'))),
//                           ],
//                         ),
//                         ...controller.newGame.map((player) {
//                           return TableRow(
//                             children: [
//                               TableCell(
//                                 child: Center(child: Text(player['round'])),
//                               ),
//                               TableCell(
//                                 child: Center(child: Text(player['name'])),
//                               ),
//                               TableCell(
//                                 child: Center(child: Text(player['score'])),
//                               ),
//                               TableCell(
//                                 child: Center(child: Text(player['total'])),
//                               ),
//                             ],
//                           );
//                         }),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.addNewPlayer('Player Name');
//                           },
//                           child: Text('Add Player'),
//                         ),
//                         TextField(
//                           decoration: InputDecoration(hintText: 'Player Name'),
//                           onSubmitted: (value) {
//                             controller.addNewPlayer(value);
//                           },
//                         ),
//                       ],
//                     ),
//                     ElevatedButton(
//                       onPressed: controller.addScore,
//                       child: Text('Add Score'),
//                     ),
//                   ],
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
