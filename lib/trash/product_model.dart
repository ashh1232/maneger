// class Product {
//   final String id;
//   final String title;
//   final String description;
//   final double rating;
//   final List<String> colors;
//   final int reviews;
//   final int stock;
//   final List<String> images;
//   final double originalPrice;
//   final double price;
//   final List<String> sizes;
//   final String color;
//   int quantity;

//   Product({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.rating,
//     required this.colors,
//     required this.reviews,
//     required this.stock,
//     required this.images,
//     required this.originalPrice,
//     required this.price,
//     required this.sizes,
//     required this.color,
//     required this.quantity,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] as String,
//       title: json['title'] as String,
//       description: json['description'] as String,
//       rating: (json['rating'] as num).toDouble(),
//       colors: List<String>.from(json['colors'] as List),
//       reviews: json['reviews'] as int,
//       stock: json['stock'] as int,
//       images: List<String>.from(json['images'] as List),
//       originalPrice: (json['originalPrice'] as num).toDouble(),
//       price: (json['price'] as num).toDouble(),
//       sizes: List<String>.from(json['sizes'] as List),
//       color: json['color'] as String,
//       quantity: json['quantity'] as int,
//     );
//   }
//   double get totalPrice => price * quantity;
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'rating': rating,
//       'colors': colors,
//       'reviews': reviews,
//       'stock': stock,
//       'images': images,
//       'originalPrice': originalPrice,
//       'price': price,
//       'sizes': sizes,
//       'color': color,
//       'quantity': quantity,
//     };
//   }
// }
