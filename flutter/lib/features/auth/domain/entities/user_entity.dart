class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String agencyName;
  final String agencyLicense;
  final String profileImage;
  final String bio;
  final double rating;
  final bool isVerified;
  final int managedUnits;
  final int closingsCount;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.agencyName = '',
    this.agencyLicense = '',
    this.profileImage = 'assets/images/generic_avatar.png',
    this.bio = '',
    this.rating = 4.9,
    this.isVerified = true,
    this.managedUnits = 24,
    this.closingsCount = 128,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? agencyName,
    String? agencyLicense,
    String? profileImage,
    String? bio,
    double? rating,
    bool? isVerified,
    int? managedUnits,
    int? closingsCount,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      agencyName: agencyName ?? this.agencyName,
      agencyLicense: agencyLicense ?? this.agencyLicense,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      managedUnits: managedUnits ?? this.managedUnits,
      closingsCount: closingsCount ?? this.closingsCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          agencyName == other.agencyName &&
          agencyLicense == other.agencyLicense &&
          profileImage == other.profileImage &&
          bio == other.bio &&
          rating == other.rating &&
          isVerified == other.isVerified &&
          managedUnits == other.managedUnits &&
          closingsCount == other.closingsCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      agencyName.hashCode ^
      agencyLicense.hashCode ^
      profileImage.hashCode ^
      bio.hashCode ^
      rating.hashCode ^
      isVerified.hashCode ^
      managedUnits.hashCode ^
      closingsCount.hashCode;
}
