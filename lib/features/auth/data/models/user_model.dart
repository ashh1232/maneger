import 'package:maneger/features/auth/domain/entities/user.dart';

/// Data Transfer Object (DTO) for User
///
/// This model is responsible for JSON serialization/deserialization.
/// It extends the domain entity and adds data layer concerns.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.imageUrl,
    super.address,
    super.city,
    super.country,
    super.createdAt,
  });

  /// Create UserModel from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['user_id'] ?? json['id'] ?? '').toString(),
      name: (json['user_name'] ?? json['username'] ?? json['name'] ?? '')
          .toString(),
      email: (json['user_email'] ?? json['email'] ?? '').toString(),
      phone: json['user_phone'] as String? ?? json['phone'] as String?,
      imageUrl: json['user_image'] as String? ?? json['image'] as String?,
      address: json['user_address'] as String? ?? json['address'] as String?,
      city: json['user_city'] as String? ?? json['city'] as String?,
      country: json['user_country'] as String? ?? json['country'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Convert UserModel to JSON (for API requests/storage)
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'user_name': name,
      'user_email': email,
      'user_phone': phone,
      'user_image': imageUrl,
      'user_address': address,
      'user_city': city,
      'user_country': country,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Create UserModel from domain Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      imageUrl: user.imageUrl,
      address: user.address,
      city: user.city,
      country: user.country,
      createdAt: user.createdAt,
    );
  }

  /// Convert to domain Entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      imageUrl: imageUrl,
      address: address,
      city: city,
      country: country,
      createdAt: createdAt,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    String? address,
    String? city,
    String? country,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Authentication response model
class AuthResponseModel {
  final String status;
  final String? message;
  final UserModel? user;
  final String? token;
  final String? refreshToken;

  const AuthResponseModel({
    required this.status,
    this.message,
    this.user,
    this.token,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String?,
      user: json['data'] != null && json['data'] is Map
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String? ?? json['auth_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  bool get isSuccess => status == 'success';
}
