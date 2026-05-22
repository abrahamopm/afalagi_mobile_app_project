class TagModel {
  final String id;
  final String name;
  final String color;
  final int propertyCount;

  TagModel({
    required this.id,
    required this.name,
    required this.color,
    this.propertyCount = 0,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#1B385E',
      propertyCount: json['propertyCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
    };
  }

  TagModel copyWith({
    String? id,
    String? name,
    String? color,
    int? propertyCount,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      propertyCount: propertyCount ?? this.propertyCount,
    );
  }
}
