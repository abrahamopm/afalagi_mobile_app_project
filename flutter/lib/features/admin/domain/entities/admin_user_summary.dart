class AdminUserSummary {
  final String id;
  final String name;
  final String email;
  final String role;
  final String agencyName;
  final String profileImage;
  final bool isVerified;
  final bool isActive;

  const AdminUserSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.agencyName = '',
    this.profileImage = 'assets/images/generic_avatar.png',
    this.isVerified = true,
    this.isActive = true,
  });

  AdminUserSummary copyWith({
    bool? isVerified,
    bool? isActive,
  }) {
    return AdminUserSummary(
      id: id,
      name: name,
      email: email,
      role: role,
      agencyName: agencyName,
      profileImage: profileImage,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }
}
