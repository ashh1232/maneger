import 'package:equatable/equatable.dart';
import 'package:maneger/features/products/domain/entities/product.dart';

/// Cart Item Entity
///
/// Represents a product in the cart with quantity and selection state.
class CartItem extends Equatable {
  final Product product;
  final int quantity;
  final bool isSelected;
  final String? selectedColor;
  final String? selectedSize;

  const CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
    this.selectedColor,
    this.selectedSize,
  });

  /// Total price for this line item
  double get totalPrice => product.price * quantity;

  /// Copy with
  CartItem copyWith({
    Product? product,
    int? quantity,
    bool? isSelected,
    String? selectedColor,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [
    product,
    quantity,
    isSelected,
    selectedColor,
    selectedSize,
  ];
}
