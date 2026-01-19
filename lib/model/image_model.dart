import 'package:maneger/features/products/domain/entities/images.dart';

class ImageModel extends Images {
  const ImageModel({required super.id, required super.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: (json['id'] ?? json['product_id'] ?? "1").toString(),
      imageUrl:
          (json['product_image'] ??
                  json['image_url'] ??
                  "https://iraq.talabat.com/assets/images/header_image-EN.png")
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': imageUrl};
  }

  Images toEntity() => this;

  factory ImageModel.fromEntity(Images image) {
    return ImageModel(id: image.id, imageUrl: image.imageUrl);
  }
}
