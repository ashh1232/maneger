import 'package:equatable/equatable.dart';

class Images extends Equatable {
  final String id;
  final String imageUrl;

  const Images({required this.id, required this.imageUrl});

  /// Business logic: Calculate discount percentage
  /// Business logic: Check if banner has action link
  bool get hasImage => imageUrl.isNotEmpty && imageUrl != 'null';

  @override
  List<Object?> get props => [id, imageUrl];

  @override
  String toString() => 'Product(id: $id)';
}
