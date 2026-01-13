// import 'package:flutter/material.dart';
// import 'package:newmanager/trash/testcontroller.dart';

// class CatList extends StatelessWidget {
//   const CatList({
//     super.key,
//     required this.testController,
//     required this.b,
//     required this.title,
//     required this.color,
//     required this.fanc,
//   });
//   final Function() fanc;
//   final bool color;
//   final String title;
//   final TestController testController;

//   final int b;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: fanc,
//       child: Container(
//         width: 120,
//         height: 30,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade500),
//           gradient: LinearGradient(
//             colors: [Colors.grey.shade100, color ? Colors.amber : Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),

//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
