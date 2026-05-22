class ClientEntity {
  final String id;
  final String name;
  final String phone;
  final String priority;
  final int interest;
  final String area;
  final String budget;
  final String image;
  final List<String> tags;

  const ClientEntity({
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

  ClientEntity copyWith({
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
    return ClientEntity(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          priority == other.priority &&
          interest == other.interest &&
          area == other.area &&
          budget == other.budget &&
          image == other.image &&
          tags.toString() == other.tags.toString();

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      priority.hashCode ^
      interest.hashCode ^
      area.hashCode ^
      budget.hashCode ^
      image.hashCode ^
      tags.toString().hashCode;
}
