import 'package:equatable/equatable.dart';

/// Pure domain entity for Category
class Category extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String? description;
  final DateTime? createdAt;

  const Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.description,
    this.createdAt,
  });

  /// Business logic: Check if category has valid image
  bool get hasImage => imageUrl.isNotEmpty && imageUrl != 'null';

  @override
  List<Object?> get props => [id, title, imageUrl, description, createdAt];

  @override
  String toString() => 'Category(id: $id, title: $title)';
}

/// Pure domain entity for Banner
class Banner extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String? link;
  final DateTime? createdAt;

  const Banner({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.link,
    this.createdAt,
  });

  /// Business logic: Check if banner has action link
  bool get hasLink => link != null && link!.isNotEmpty;

  @override
  List<Object?> get props => [id, title, imageUrl, link, createdAt];

  @override
  String toString() => 'Banner(id: $id, title: $title)';
}
