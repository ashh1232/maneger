class Order {
  final String orderId;
  final String userId;
  final double total;
  final double subtotal;
  final double tax;
  final double shipping;
  final String status;
  final String paymentMethod;
  final String paymentStatus;

  // Delivery information
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryCountry;

  // Additional
  final String? orderNotes;
  final String createdAt;
  final List<OrderItem>? items;

  Order({
    required this.orderId,
    required this.userId,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.deliveryCountry,
    this.orderNotes,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'].toString(),
      userId: json['user_id'].toString(),
      total: double.parse(json['order_total'].toString()),
      subtotal: double.parse(json['order_subtotal'].toString()),
      tax: double.parse(json['order_tax'].toString()),
      shipping: double.parse(json['order_shipping']?.toString() ?? '0'),
      status: json['order_status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      deliveryName: json['delivery_name'] as String,
      deliveryPhone: json['delivery_phone'] as String,
      deliveryAddress: json['delivery_address'] as String,
      deliveryCity: json['delivery_city'] as String,
      deliveryCountry: json['delivery_country'] as String,
      orderNotes: json['order_notes'] as String?,
      createdAt: json['created_at'] as String,
      items:
          json['items'] != null
              ? (json['items'] as List)
                  .map((i) => OrderItem.fromJson(i))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'order_total': total,
      'order_subtotal': subtotal,
      'order_tax': tax,
      'order_shipping': shipping,
      'order_status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'delivery_name': deliveryName,
      'delivery_phone': deliveryPhone,
      'delivery_address': deliveryAddress,
      'delivery_city': deliveryCity,
      'delivery_country': deliveryCountry,
      'order_notes': orderNotes,
      'created_at': createdAt,
    };
  }
}

class OrderItem {
  final String itemId;
  final String orderId;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final double itemTotal;

  OrderItem({
    required this.itemId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.itemTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['item_id'].toString(),
      orderId: json['order_id'].toString(),
      productId: json['product_id'].toString(),
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String,
      productPrice: double.parse(json['product_price'].toString()),
      quantity: int.parse(json['item_quantity'].toString()),
      itemTotal: double.parse(json['item_total'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'product_price': productPrice,
      'quantity': quantity,
    };
  }
}
