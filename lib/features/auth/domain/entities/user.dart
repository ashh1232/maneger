import 'package:equatable/equatable.dart';

/// Pure domain entity for User
///
/// This is the business logic representation of a user.
/// No JSON,no dependencies - can be tested without Flutter.
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.address,
    this.city,
    this.country,
    this.createdAt,
  });

  /// Business logic: Check if user has completed their profile
  bool get hasCompletedProfile {
    return phone != null &&
        phone!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty;
  }

  /// Business logic: Get display name
  String get displayName => name.isNotEmpty ? name : email;

  /// Business logic: Check if profile image exists
  bool get hasProfileImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Copy with for immutability
  User copyWith({
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
    return User(
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

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    imageUrl,
    address,
    city,
    country,
    createdAt,
  ];

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
