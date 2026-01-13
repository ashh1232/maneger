// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/trash/testcontroller.dart';
// import 'package:newmanager/trash/ani_appbar_screen.dart';
// // import 'package:newmanager/screen/home_screen.dart';
// // import 'discover_screen.dart';
// import 'edit_cat_screen.dart';
// import 'profile_screen.dart';

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});
//   final int cartItemCount = 4;
//   final bool isNavCatVisible = true;

//   @override
//   Widget build(BuildContext context) {
//     final TestController controller = Get.find();

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(255, 0, 0, 0),
//               offset: Offset(4, 4),
//             ),
//             BoxShadow(
//               color: Colors.red,
//               offset: Offset(-44, -4),
//               spreadRadius: 55,
//             ),
//           ],
//         ),

//         child: Column(
//           children: [
//             SizedBox(
//               height: context.height - 200,
//               child: PageView(
//                 controller: controller.pageController,
//                 onPageChanged: controller.updatePage,
//                 children: [
//                   // HomeScreen(),
//                   AniAppbarScreen(),
//                   CatScreen(),
//                   // DiscoverScreen(), // يستخدم DiscoverController الخاص به
//                   UserPage(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       bottomNavigationBar: Obx(
//         () => Container(
//           color: Colors.grey.shade300,
//           child: BottomNavigationBar(
//             backgroundColor: Colors.grey.shade300,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'الرئيسية',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.category),
//                 label: 'الفئات',
//               ),
//               // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
//               BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
//             ],
//             currentIndex: controller.currentPage.value,
//             selectedItemColor: Colors.black87,
//             onTap: (index) => controller.pageController.jumpToPage(index),
//           ),
//         ),
//       ),
//     );
//   }
// }
