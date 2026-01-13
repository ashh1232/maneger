// class Product {
//   final int id;
//   final String name;
//   final double price;
//   final String image;
//   final int proCat;
//   final int catId;
//   final String catName;
//   final String catImage;
//   final int catMain;

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.image,
//     required this.proCat,
//     required this.catId,
//     required this.catName,
//     required this.catImage,
//     required this.catMain,
//   });

//   // Factory constructor to create a Product instance from a Map (JSON decoding)
//   factory Product.fromJson(Map<String, dynamic> json) {
//     // We use 'num' casting for prices to handle potential int/double ambiguity from raw JSON
//     return Product(
//       id: json['product_id'] as int,
//       name: json['product_name'] as String,
//       price: (json['product_price'] as num).toDouble(),
//       image: json['product_image'] as String,
//       proCat: json['product_cat'] as int,
//       catId: json['categories_id'] as int,
//       catName: json['categories_name'] as String,
//       catImage: json['categories_image'] as String,
//       catMain: json['cat_main'] as int,
//     );
//   }

//   // Optional: Add a toJson method if you need to encode Dart objects back into JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'product_id': id,
//       'product_name': name,
//       'product_price': price,
//       'product_image': image,
//       'product_cat': proCat,
//       'categories_id': catId,
//       'categories_name': catName,
//       'categories_image': catImage,
//       'cat_main': catMain,
//     };
//   }
// }
