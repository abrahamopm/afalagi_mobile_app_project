class TagEntity {
  final String id;
  final String name;
  final String color;
  final int propertyCount;

  const TagEntity({
    required this.id,
    required this.name,
    required this.color,
    this.propertyCount = 0,
  });

  TagEntity copyWith({
    String? id,
    String? name,
    String? color,
    int? propertyCount,
  }) {
    return TagEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      propertyCount: propertyCount ?? this.propertyCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          propertyCount == other.propertyCount;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ color.hashCode ^ propertyCount.hashCode;
}
