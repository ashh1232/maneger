// class Product {
//   final String id;
//   final String title;
//   final String image;
//   final int price;
//   final String description;

//   // 'var quantity;' is replaced by 'int quantity;'
//   // Fields that are not final must be initialized or nullable.
//   int quantity;

//   // --- Factory Method for Firestore Deserialization ---
//   // This is used to create a Product object from data fetched from the database.
//   factory Product.fromFirestore(Map<String, dynamic> json, String documentId) {
//     return Product(
//       id: documentId,
//       title: json['title'] as String,
//       image: json['image'] as String,
//       price: json['price'] as int,
//       description: json['description'] as String,
//       // Use null-aware operators (??) for safety
//       quantity: json['quantity'] as int? ?? 1,
//     );
//   }

//   // --- Main Constructor ---
//   // Use named parameters for clarity and flexibility (recommended in Flutter)
//   Product({
//     required this.price,
//     required this.description,
//     required this.id,
//     required this.title,
//     required this.image,
//     this.quantity = 1, // Default value if not provided
//   });
// }
