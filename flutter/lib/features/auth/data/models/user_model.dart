class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String agencyName;
  final String agencyLicense;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.agencyName = '',
    this.agencyLicense = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      agencyName: json['agencyName'] ?? '',
      agencyLicense: json['agencyLicense'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'agencyName': agencyName,
      'agencyLicense': agencyLicense,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? agencyName,
    String? agencyLicense,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      agencyName: agencyName ?? this.agencyName,
      agencyLicense: agencyLicense ?? this.agencyLicense,
    );
  }
}
