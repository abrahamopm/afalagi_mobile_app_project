import '../../domain/entities/tag_entity.dart';
import '../../../../core/database/database_tables.dart';

class TagModel extends TagEntity {
  const TagModel({
    required super.id,
    required super.name,
    required super.color,
    super.propertyCount,
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

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map[DatabaseTables.colTagId] ?? '',
      name: map[DatabaseTables.colTagName] ?? '',
      color: map[DatabaseTables.colTagColor] ?? '',
      propertyCount: map[DatabaseTables.colTagPropertyCount] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseTables.colTagId: id,
      DatabaseTables.colTagName: name,
      DatabaseTables.colTagColor: color,
      DatabaseTables.colTagPropertyCount: propertyCount,
    };
  }

  factory TagModel.fromEntity(TagEntity entity) {
    return TagModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      propertyCount: entity.propertyCount,
    );
  }
}
