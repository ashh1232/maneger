class OrderModel {
  final int orderId;
  final double orderTotal;
  final String orderStatus;
  final DateTime createdAt;
  final int itemCount;

  OrderModel({
    required this.orderId,
    required this.orderTotal,
    required this.orderStatus,
    required this.createdAt,
    required this.itemCount,
  });

  // تحويل من Map (JSON) إلى Object
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      // التأكد من تحويل النص إلى رقم عشري
      orderTotal: double.parse(json['order_total'].toString()),
      orderStatus: json['order_status'].toString(),
      // تحويل نص التاريخ إلى كائن DateTime
      createdAt: DateTime.parse(json['created_at']),
      itemCount: json['item_count'] ?? 0,
    );
  }

  // تحويل من Object إلى Map (لإرساله للسيرفر مثلاً)
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_total': orderTotal.toString(),
      'order_status': orderStatus,
      'created_at': createdAt.toIso8601String(),
      'item_count': itemCount,
    };
  }
}
