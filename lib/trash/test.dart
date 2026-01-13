// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:newmanager/trash/product_model.dart';
// // import 'package:newmanager/widget/ProductCard.dart';

// class AniAppBarrScreen extends StatefulWidget {
//   const AniAppBarrScreen({super.key});

//   @override
//   State<AniAppBarrScreen> createState() => _AniAppBarrScreenState();
// }

// bool _isScrolled = false;
// final List<Product> products = [
//   Product(
//     id: '1',
//     title: 'a',
//     description: 'Product description',
//     rating: 4.5,
//     colors: [],
//     reviews: 0,
//     stock: 10,
//     images: ['http://10.0.2.2/img/image1.jpg'],
//     originalPrice: 2.0,
//     price: 3.0,
//     sizes: [],
//     color: '',
//     quantity: 1,
//   ),
//   Product(
//     id: '2',
//     title: 'ddd',
//     description: 'Product description',
//     rating: 4.5,
//     colors: [],
//     reviews: 0,
//     stock: 10,
//     images: ['http://10.0.2.2/img/image1.jpg'],
//     originalPrice: 2.0,
//     price: 3.0,
//     sizes: [],
//     color: '',
//     quantity: 1,
//   ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
//   // Product(
//   //   title: 'ddd',
//   //   img: 'http://10.0.2.2/img/image1.jpg',
//   //   price: 3,
//   //   originalPrice: 2,
//   // ),
// ];

// class _AniAppBarrScreenState extends State<AniAppBarrScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       // appBar: CustomHeader(),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(110),
//         child: AppBar(
//           elevation: _isScrolled ? 4 : 0,
//           backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
//           systemOverlayStyle:
//               _isScrolled
//                   ? SystemUiOverlayStyle.dark
//                   : SystemUiOverlayStyle.light,
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
//                         color: _isScrolled ? Colors.black : Colors.white,
//                         size: 28,
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Container(
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color:
//                                 _isScrolled ? Colors.grey[100] : Colors.white,
//                             borderRadius: BorderRadius.circular(30),
//                             border:
//                                 _isScrolled
//                                     ? Border.all(color: Colors.grey[300]!)
//                                     : null,
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
//                         color: _isScrolled ? Colors.black : Colors.white,
//                         size: 26,
//                       ),
//                       SizedBox(width: 10),
//                       Icon(
//                         Icons.mail_outline,
//                         color: _isScrolled ? Colors.black : Colors.white,
//                         size: 28,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.menu,
//                         color: _isScrolled ? Colors.black : Colors.white,
//                         size: 30,
//                       ),
//                       SizedBox(width: 15),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: [
//                               SizedBox(width: 10),

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
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification) {
//           if (ScrollNotification.metrics.pixels > 50) {
//             if (!_isScrolled) setState(() => _isScrolled = true);
//           } else {
//             if (_isScrolled) setState(() => _isScrolled = false);
//           }
//           return true;
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 350,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   // color: Colors.white,
//                   // borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: NetworkImage('http://10.0.2.2/img/image1.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Container(color: Colors.black26),
//               ),
//               Container(
//                 color: Colors.grey[100],
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 50,
//                       margin: EdgeInsets.only(bottom: 10),
//                       color: Colors.pink[50],
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Center(
//                             child: Text(
//                               'free shoping bla bla',
//                               style: TextStyle(color: Colors.purple),
//                             ),
//                           ),

//                           Center(
//                             child: Text(
//                               'free shoping bla bla',
//                               style: TextStyle(color: Colors.purple),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // MasonryGridView.count(
//                     //   shrinkWrap: true,
//                     //   physics: NeverScrollableScrollPhysics(),

//                     //   crossAxisCount: 2,
//                     //   mainAxisSpacing: 10,
//                     //   crossAxisSpacing: 10,
//                     //   itemCount: products.length,
//                     //   itemBuilder: (context, index) {
//                     //     return ProductCard(product: products[index]);
//                     //   },
//                     // ),
//                     Container(
//                       height: 200,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         // child: GridView.builder(
//                         //   scrollDirection: Axis.horizontal,
//                         //   shrinkWrap: true,
//                         //   physics: NeverScrollableScrollPhysics(),
//                         //   gridDelegate:
//                         //       SliverGridDelegateWithFixedCrossAxisCount(
//                         //         crossAxisCount: 2,
//                         //         childAspectRatio: 0.7,
//                         //         crossAxisSpacing: 10,
//                         //         mainAxisSpacing: 10,
//                         //       ),
//                         //   itemCount: 10,
//                         //   itemBuilder:
//                         //       (asd, i) => ProductCard(product: products[i]),
//                         // ),
//                       ),
//                     ),
//                     // GridView.builder(
//                     //   shrinkWrap: true,
//                     //   physics: NeverScrollableScrollPhysics(),
//                     //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     //     crossAxisCount: 2,
//                     //     childAspectRatio: 0.7,
//                     //     crossAxisSpacing: 10,
//                     //     mainAxisSpacing: 10,
//                     //   ),
//                     //   itemCount: products.length,
//                     //   // itemBuilder:
//                     //       // (asd, i) => ProductCard(product: products[i]),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
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
//               color: _isScrolled ? Colors.black87 : Colors.white,
//               fontSize: 16,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               shadows:
//                   _isScrolled
//                       ? []
//                       : [
//                         Shadow(
//                           offset: Offset(0, 1),
//                           blurRadius: 2,
//                           color: Colors.black45,
//                         ),
//                       ],
//             ),
//           ),
//           if (isSelected)
//             Container(
//               padding: EdgeInsets.only(bottom: 5),
//               margin: EdgeInsets.only(top: 4, bottom: _isScrolled ? 5 : 1),
//               height: 2,
//               width: 20,
//               color: _isScrolled ? Colors.black87 : Colors.white,
//             ),
//         ],
//       ),
//     );
//   }
// }
