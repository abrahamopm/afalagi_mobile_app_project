import '../domain/entities/client_entity.dart';

class Client extends ClientEntity {
  const Client({
    required super.id,
    required super.name,
    required super.phone,
    super.priority,
    super.interest,
    super.area,
    super.budget,
    super.image,
    super.tags,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      priority: json['priority'] ?? 'MODERATE',
      interest: json['interest'] ?? 3,
      area: json['area'] ?? '',
      budget: json['budget'] ?? '',
      image: json['image'] ?? 'assets/images/generic_avatar.png',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'priority': priority,
      'interest': interest,
      'area': area,
      'budget': budget,
      'image': image,
      'tags': tags,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? phone,
    String? priority,
    int? interest,
    String? area,
    String? budget,
    String? image,
    List<String>? tags,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      priority: priority ?? this.priority,
      interest: interest ?? this.interest,
      area: area ?? this.area,
      budget: budget ?? this.budget,
      image: image ?? this.image,
      tags: tags ?? this.tags,
    );
  }
}
