class Client {
  final String id;
  final String name;
  final String phone;
  final String priority; // 'VIP' | 'HIGH' | 'MODERATE' | 'LOW'
  final int interest; // 1-5
  final String area;
  final String budget;
  final String image;
  final List<String> tags;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    this.priority = 'MODERATE',
    this.interest = 3,
    this.area = '',
    this.budget = '',
    this.image = 'assets/images/generic_avatar.png',
    this.tags = const [],
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
