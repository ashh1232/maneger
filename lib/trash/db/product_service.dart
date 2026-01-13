// // Example: product_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:newmanager/db/cat_model.dart';
// import 'product_model.dart'; // Make sure you define your Product class here

// class ProductService {
//   // Reference to the 'products' collection in Firestore
//   final CollectionReference productsCollection = FirebaseFirestore.instance
//       .collection('products');
//   Future<List<Category>> getCategories() async {
//     try {
//       // Get all documents from the 'products' collection
//       QuerySnapshot querySnapshot = await productsCollection.get();

//       // Convert the raw data into a list of type-safe Product objects
//       List<Category> category =
//           querySnapshot.docs.map((doc) {
//             return Category.fromFirestore(
//               doc.data() as Map<String, dynamic>,
//               doc.id, // Use the unique document ID as the product 'id'
//             );
//           }).toList();

//       return category;
//     } catch (e) {
//       print("Error fetching products: $e");
//       return []; // Return an empty list on error
//     }
//   }

//   // Function to fetch products from Firebase
//   Future<List<Product>> getProducts() async {
//     try {
//       // Get all documents from the 'products' collection
//       QuerySnapshot querySnapshot = await productsCollection.get();

//       // Convert the raw data into a list of type-safe Product objects
//       List<Product> products =
//           querySnapshot.docs.map((doc) {
//             return Product.fromFirestore(
//               doc.data() as Map<String, dynamic>,
//               doc.id, // Use the unique document ID as the product 'id'
//             );
//           }).toList();

//       return products;
//     } catch (e) {
//       print("Error fetching products: $e");
//       return []; // Return an empty list on error
//     }
//   }

//   // Function to add a new product to Firestore
//   Future<void> addProduct(
//     String title,
//     String img,
//     String description,
//     int price,
//   ) async {
//     try {
//       await productsCollection.add({
//         // This Map must match the field names in your Firebase Console exactly
//         'price': price,
//         'description': description,
//         'title': title,
//         "image": img,
//         'quantity':
//             1, // Default value, or you could pass this in as a parameter
//         // Add other fields here if your model requires them, e.g., 'price': 99.99
//       });
//       print("Product '$title' added successfully!");
//     } catch (e) {
//       print("Error adding product: $e");
//       // Handle error appropriately (show a dialog, etc.)
//       rethrow; // Re-throw the error so the UI layer can catch it if needed
//     }
//   }
// }
