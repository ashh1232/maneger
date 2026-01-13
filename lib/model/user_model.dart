class User {
  final String userId;
  final String userName;
  final String userEmail;
  final String? userPhone;
  final String? userImage;
  final String? userAddress;
  final String? userCity;
  final String? userCountry;
  final String? createdAt;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhone,
    this.userImage,
    this.userAddress,
    this.userCity,
    this.userCountry,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'].toString(),
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      userPhone: json['user_phone'] as String?,
      userImage: json['user_image'] as String?,
      userAddress: json['user_address'] as String?,
      userCity: json['user_city'] as String?,
      userCountry: json['user_country'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'user_image': userImage,
      'user_address': userAddress,
      'user_city': userCity,
      'user_country': userCountry,
    };
  }

  // Helper method to get full image URL
  String? get fullImageUrl {
    if (userImage == null || userImage!.isEmpty) return null;
    // Assuming your server URL from linkapi.dart
    if (userImage!.startsWith('http')) return userImage;
    return 'http://192.168.0.154/$userImage';
  }

  // Helper method to get display name
  String get displayName => userName.isNotEmpty ? userName : userEmail;
}
