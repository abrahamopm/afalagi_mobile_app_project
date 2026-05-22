class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String agencyName;
  final String agencyLicense;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.agencyName = '',
    this.agencyLicense = '',
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? agencyName,
    String? agencyLicense,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      agencyName: agencyName ?? this.agencyName,
      agencyLicense: agencyLicense ?? this.agencyLicense,
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
          agencyLicense == other.agencyLicense;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      agencyName.hashCode ^
      agencyLicense.hashCode;
}
