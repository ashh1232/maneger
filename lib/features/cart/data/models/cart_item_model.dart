import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/products/data/models/product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.product,
    super.quantity = 1,
    super.isSelected = true,
    super.selectedColor,
    super.selectedSize,
  });

  /// Factory from Json
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // The previous implementation stored Product fields directly in the list item
    // plus 'quantity' and 'isSelected'.
    // We should support that format.
    // However, clean architecture suggests nesting.
    // If the legacy structure was flat, we need to adapt.
    //
    // Legacy structure from CartControllerw:
    // list.map((p) => p.toJson()).toList()
    // ProductModel's toJson() includes product fields + quantity + isSelected.
    //
    // So 'json' here acts like a ProductModel, but we wrap it in CartItemModel.

    final product = ProductModel.fromJson(json); // This parses product fields

    // Extract cart specific fields separately if they exist in the root map
    final int quantity = json['quantity'] is int ? json['quantity'] : 1;
    final bool isSelected = json['isSelected'] is bool
        ? json['isSelected']
        : true;
    final String? selectedColor = json['selectedColor'];
    final String? selectedSize = json['selectedSize'];

    return CartItemModel(
      product: product, // Using the polymorphic ProductModel as Product
      quantity: quantity,
      isSelected: isSelected,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
    );
  }

  /// To Json
  Map<String, dynamic> toJson() {
    // We can choose to store it flat (backward compatible) or nested.
    // Let's store it flat to be compatible if we revert, OR cleaner nested.
    // Since we are migrating, let's keep it flat for now to match 'ProductModel' expectations if any.
    // Actually, ProductModel.toJson() creates the map. We can just add our fields.

    // Cast product to ProductModel if possible, or create one
    final productModel = ProductModel.fromEntity(product);
    final map = productModel.toJson();

    // The ProductModel.toJson includes 'quantity' and 'isSelected' if we modified ProductModel?
    // Let's check ProductModel.
    // If ProductModel DOES NOT have quantity, we add it.

    map['quantity'] = quantity;
    map['isSelected'] = isSelected;
    if (selectedColor != null) map['selectedColor'] = selectedColor;
    if (selectedSize != null) map['selectedSize'] = selectedSize;

    return map;
  }

  /// Mapper from Entity
  factory CartItemModel.fromEntity(CartItem cartItem) {
    return CartItemModel(
      product: cartItem.product,
      quantity: cartItem.quantity,
      isSelected: cartItem.isSelected,
      selectedColor: cartItem.selectedColor,
      selectedSize: cartItem.selectedSize,
    );
  }
}
