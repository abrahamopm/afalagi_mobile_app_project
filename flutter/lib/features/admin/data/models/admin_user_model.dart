import '../../domain/entities/admin_user_summary.dart';

class AdminUserModel extends AdminUserSummary {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.agencyName,
    super.profileImage,
    super.isVerified,
    super.isActive,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      agencyName: json['agencyName'] ?? '',
      profileImage: json['profileImage'] ?? 'assets/images/generic_avatar.png',
      isVerified: json['isVerified'] ?? true,
      isActive: json['isActive'] ?? true,
    );
  }
}
