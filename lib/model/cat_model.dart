class Category {
  final String id;
  final String title;
  final String image;
  final int type;

  // 'var quantity;' is replaced by 'int quantity;'
  // Fields that are not final must be initialized or nullable.
  // int quantity;

  // --- Factory Method for Firestore Deserialization ---
  // This is used to create a Product object from data fetched from the database.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] ?? json['categories_id'] ?? "1").toString(),
      title:
          (json['title'] ?? json['categories_name'] ?? "بدون عنوان").toString(),
      image: json['categories_image'] as String,
      type: json['cat_main'] as int,
      // Use null-aware operators (??) for safety
      // quantity: json['quantity'] as int? ?? 1,
    );
  }

  // --- Main Constructor ---
  // Use named parameters for clarity and flexibility (recommended in Flutter)
  Category({
    required this.type,
    required this.id,
    required this.title,
    required this.image,
    // this.quantity = 1, // Default value if not provided
  });
}
