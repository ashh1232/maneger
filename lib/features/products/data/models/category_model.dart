import 'package:maneger/features/products/domain/entities/category.dart';

/// Data Transfer Object for Category
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.description,
    super.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? json['categories_id'] ?? '1').toString(),
      title: (json['title'] ?? json['categories_name'] ?? json['name'] ?? '')
          .toString(),
      imageUrl: (json['categories_image'] ?? json['cat_image'] ?? '')
          .toString(),
      description:
          json['description'] as String? ?? json['cat_desc'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Category toEntity() => this;

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      title: category.title,
      imageUrl: category.imageUrl,
      description: category.description,
      createdAt: category.createdAt,
    );
  }
}

/// Data Transfer Object for Banner
class BannerModel extends Banner {
  const BannerModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.link,
    super.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: (json['id'] ?? json['banner_id'] ?? '0').toString(),
      title: (json['title'] ?? json['banner_title'] ?? '').toString(),
      imageUrl: (json['image'] ?? json['banner_image'] ?? '').toString(),
      link: json['link'] as String? ?? json['banner_link'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
      'link': link,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Banner toEntity() => this;

  factory BannerModel.fromEntity(Banner banner) {
    return BannerModel(
      id: banner.id,
      title: banner.title,
      imageUrl: banner.imageUrl,
      link: banner.link,
      createdAt: banner.createdAt,
    );
  }
}
