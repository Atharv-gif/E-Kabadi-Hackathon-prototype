enum UserRole { citizen, collector }

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final String address;
  final double rating;
  final bool isVerified;
  final int ecoPoints;
  final int ecoCoins;
  final String profilePhoto;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.address,
    this.rating = 4.8,
    this.isVerified = true,
    this.ecoPoints = 840,
    this.ecoCoins = 1250,
    this.profilePhoto = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] == 'collector' ? UserRole.collector : UserRole.citizen,
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 4.8).toDouble(),
      isVerified: json['isVerified'] ?? true,
      ecoPoints: json['ecoPoints'] ?? 840,
      ecoCoins: json['ecoCoins'] ?? 1250,
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role.name,
      'address': address,
      'rating': rating,
      'isVerified': isVerified,
      'ecoPoints': ecoPoints,
      'ecoCoins': ecoCoins,
      'profilePhoto': profilePhoto,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    String? address,
    double? rating,
    bool? isVerified,
    int? ecoPoints,
    int? ecoCoins,
    String? profilePhoto,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      ecoPoints: ecoPoints ?? this.ecoPoints,
      ecoCoins: ecoCoins ?? this.ecoCoins,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
