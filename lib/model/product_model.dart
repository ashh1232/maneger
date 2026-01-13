class Product {
  final String id;
  final String title;
  final String price;
  final String image;
  final String categoryId;
  final String originalPrice;
  final String description;
  final String blurHash; // الحقل الجديد
  String catName;
  bool isSelected;
  int quantity;

  Product({
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.id,
    required this.title,
    required this.image,
    required this.categoryId,
    required this.blurHash, // مطلوب في الـ Constructor
    this.isSelected = true,
    this.quantity = 1,
    this.catName = '1',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? json['product_id'] ?? "1").toString(),
      title: (json['title'] ?? json['product_name'] ?? "بدون عنوان").toString(),
      price: (json['price'] ?? json['product_price'] ?? "0").toString(),
      image:
          (json['image'] ??
                  json['product_image'] ??
                  "https://iraq.talabat.com/assets/images/header_image-EN.png")
              .toString(),
      categoryId: (json['categoryId'] ?? json['product_cat'] ?? "1").toString(),
      originalPrice:
          (json['originalPrice'] ?? json['original_price'] ?? "0.0").toString(),
      description:
          (json['description'] ?? json['product_desc'] ?? "بدون وصف")
              .toString(),

      // استقبال الـ BlurHash من السيرفر (تأكد من مطابقة الاسم مع عمود قاعدة البيانات)
      blurHash:
          (json['product_blurhash'] ?? "UBEVsa9E0M~q~T%ND%x^01-:wbITt8t6%hxa")
              .toString(),

      quantity:
          json['quantity'] is int
              ? json['quantity']
              : int.tryParse(json['quantity']?.toString() ?? "1") ?? 1,
      catName:
          (json['cat_name'] ?? json['categories_name'] ?? "بدون عنوان")
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'originalPrice': originalPrice,
      'price': price,
      'quantity': quantity,
      'product_blurhash': blurHash, // إضافة الحقل هنا أيضاً
    };
  }

  int get totalPrice {
    try {
      return (int.tryParse(price) ?? 0) * quantity;
    } catch (e) {
      return 0;
    }
  }
}
