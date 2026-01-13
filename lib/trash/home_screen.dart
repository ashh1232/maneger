// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:newmanager/trash/product_model.dart';
// // import 'package:newmanager/widget/custom_header.dart';
// // import 'package:newmanager/widget/ProductCard.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});
//   final List<Product> products = [
//     Product(
//       id: '1',
//       title: 'ddd',
//       description: 'Product description',
//       rating: 4.5,
//       colors: [],
//       reviews: 0,
//       stock: 10,
//       images: ['http://192.168.0.144/img/image1.jpg'],
//       originalPrice: 2.0,
//       price: 3.0,
//       sizes: [],
//       color: '',
//       quantity: 1,
//     ),
//     Product(
//       id: '2',
//       title: 'ddd',
//       description: 'Product description',
//       rating: 4.5,
//       colors: [],
//       reviews: 0,
//       stock: 10,
//       images: ['http://10.0.2.2/img/image1.jpg'],
//       originalPrice: 2.0,
//       price: 3.0,
//       sizes: [],
//       color: '',
//       quantity: 1,
//     ),
//     Product(
//       id: '3',
//       title: 'ddd',
//       description: 'Product description',
//       rating: 4.5,
//       colors: [],
//       reviews: 0,
//       stock: 10,
//       images: ['http://10.0.2.2/img/image1.jpg'],
//       originalPrice: 2.0,
//       price: 3.0,
//       sizes: [],
//       color: '',
//       quantity: 1,
//     ),
//     Product(
//       id: '4',
//       title: 'ddd',
//       description: 'Product description',
//       rating: 4.5,
//       colors: [],
//       reviews: 0,
//       stock: 10,
//       images: ['http://10.0.2.2/img/image1.jpg'],
//       originalPrice: 2.0,
//       price: 3.0,
//       sizes: [],
//       color: '',
//       quantity: 1,
//     ),
//     Product(
//       id: '5',
//       title: 'ddd',
//       description: 'Product description',
//       rating: 4.5,
//       colors: [],
//       reviews: 0,
//       stock: 10,
//       images: ['http://10.0.2.2/img/image1.jpg'],
//       originalPrice: 2.0,
//       price: 3.0,
//       sizes: [],
//       color: '',
//       quantity: 1,
//     ),
//   ];
//   //  [
//   //   (
//   //     title: '1pc mini',
//   //     img: 'asdf',
//   //     price: 0.53,
//   //     originalPrice: 2.0,
//   //     // discount: '23%',
//   //     // badge: '2Bestseller',
//   //     // rating: 4.8,
//   //     // sold: 300,
//   //     // isTrends: false,
//   //   ),
//   //   (
//   //     title: '1pc mini',
//   //     img: 'asdf',
//   //     price: 0.53,
//   //     originalPrice: 2.0,
//   //     // discount: '23%',
//   //     // badge: '2Bestseller',
//   //     // rating: 4.8,
//   //     // sold: 300,
//   //     // isTrends: false,
//   //   ),
//   //   (
//   //     title: '1pc mini',
//   //     img: 'asdf',
//   //     price: 0.53,
//   //     originalPrice: 2.0,
//   //     // discount: '23%',
//   //     // badge: '2Bestseller',
//   //     // rating: 4.8,
//   //     // sold: 300,
//   //     // isTrends: false,
//   //   ),
//   //   (
//   //     title: '1pc mini',
//   //     img: 'asdf',
//   //     price: 0.53,
//   //     originalPrice: 2.0,
//   //     // discount: '23%',
//   //     // badge: '2Bestseller',
//   //     // rating: 4.8,
//   //     // sold: 300,
//   //     // isTrends: false,
//   //   ),
//   // ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       // appBar: CustomHeader(),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(110),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//           flexibleSpace: SafeArea(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 // SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.favorite_border,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Container(
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Icon(Icons.search, color: Colors.grey, size: 22),
//                               SizedBox(width: 5),
//                               Expanded(
//                                 child: Text(
//                                   'ملابس رجالي و ستاتي ',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.camera_alt_outlined,
//                                 color: Colors.grey,
//                                 size: 22,
//                               ),
//                               SizedBox(width: 10),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(
//                         Icons.calendar_today_outlined,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                       SizedBox(width: 10),
//                       Icon(Icons.mail_outline, color: Colors.white, size: 28),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       Icon(Icons.menu, color: Colors.white, size: 30),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               _buildCategoryItem("kids"),
//                               _buildCategoryItem("shoes"),
//                               _buildCategoryItem("electronics"),
//                               _buildCategoryItem("woman"),
//                               _buildCategoryItem("men"),
//                               _buildCategoryItem("men"),
//                               _buildCategoryItem("all", isSelected: true),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 300,
//             // child:
//             //  CustomHeader()
//           ),
//           _buildPinkInfoBar(),
//           Container(
//             height: 900,
//             child: MasonryGridView.count(
//               crossAxisCount: 2,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 return Text('dasta');
//                 //  ProductCard(product: products[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPinkInfoBar() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.pink[50],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'flash sale',
//                           style: TextStyle(
//                             color: Colors.purple,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Icon(Icons.flash_on, color: Colors.purple, size: 20),
//                       ],
//                     ),
//                     Text(
//                       'view more',
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(height: 40, width: 1, color: Colors.pink[200]),
//           Expanded(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'free shipping',
//                       style: TextStyle(
//                         color: Colors.purple,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Icon(Icons.local_shipping, color: Colors.purple, size: 20),
//                   ],
//                 ),
//                 Text(
//                   'Buy \$114.00 more to get',
//                   style: TextStyle(color: Colors.purple[300], fontSize: 11),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryItem(String title, {bool isSelected = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               shadows: [
//                 Shadow(
//                   offset: Offset(0, 1),
//                   blurRadius: 2,
//                   color: Colors.black45,
//                 ),
//               ],
//             ),
//           ),
//           if (isSelected)
//             Container(
//               margin: EdgeInsets.only(top: 4),
//               height: 2,
//               width: 20,
//               color: Colors.white,
//             ),
//         ],
//       ),
//     );
//   }
// }
