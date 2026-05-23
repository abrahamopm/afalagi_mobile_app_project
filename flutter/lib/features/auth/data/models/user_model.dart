import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.role,
    super.phone,
    super.agencyName,
    super.agencyLicense,
    super.profileImage,
    super.bio,
    super.rating,
    super.isVerified,
    super.isActive,
    super.managedUnits,
    super.closingsCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      phone: json['phone'] ?? '',
      agencyName: json['agencyName'] ?? '',
      agencyLicense: json['agencyLicense'] ?? '',
      profileImage: json['profileImage'] ?? 'assets/images/generic_avatar.png',
      bio: json['bio'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      isVerified: json['isVerified'] ?? true,
      isActive: json['isActive'] ?? true,
      managedUnits: json['managedUnits'] as int? ?? 24,
      closingsCount: json['closingsCount'] as int? ?? 128,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'agencyName': agencyName,
      'agencyLicense': agencyLicense,
      'profileImage': profileImage,
      'bio': bio,
      'rating': rating,
      'isVerified': isVerified,
      'isActive': isActive,
      'managedUnits': managedUnits,
      'closingsCount': closingsCount,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phone: entity.phone,
      agencyName: entity.agencyName,
      agencyLicense: entity.agencyLicense,
      profileImage: entity.profileImage,
      bio: entity.bio,
      rating: entity.rating,
      isVerified: entity.isVerified,
      isActive: entity.isActive,
      managedUnits: entity.managedUnits,
      closingsCount: entity.closingsCount,
    );
  }
}
