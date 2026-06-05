import 'dart:convert';
import '../../domain/entities/property_entity.dart';
import '../../../../core/database/database_tables.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.imageUrl,
    required super.price,
    required super.beds,
    required super.baths,
    required super.sqft,
    super.isAvailable,
    super.tags,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? 'No description available',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/generic_property.png',
      price: (json['price'] ?? 0).toDouble(),
      beds: json['beds'] ?? 0,
      baths: json['baths'] ?? 0,
      sqft: json['sqft'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'isAvailable': isAvailable,
      'tags': tags,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    List<String> tagsList = [];
    try {
      if (map[DatabaseTables.colPropTags] != null) {
        tagsList = List<String>.from(jsonDecode(map[DatabaseTables.colPropTags] as String));
      }
    } catch (_) {}

    return PropertyModel(
      id: map[DatabaseTables.colPropId] ?? '',
      title: map[DatabaseTables.colPropTitle] ?? '',
      description: map[DatabaseTables.colPropDescription] ?? '',
      location: map[DatabaseTables.colPropLocation] ?? '',
      imageUrl: map[DatabaseTables.colPropImageUrl] ?? '',
      price: (map[DatabaseTables.colPropPrice] ?? 0.0).toDouble(),
      beds: map[DatabaseTables.colPropBeds] ?? 0,
      baths: map[DatabaseTables.colPropBaths] ?? 0,
      sqft: map[DatabaseTables.colPropSqft] ?? 0,
      isAvailable: (map[DatabaseTables.colPropIsAvailable] ?? 1) == 1,
      tags: tagsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseTables.colPropId: id,
      DatabaseTables.colPropTitle: title,
      DatabaseTables.colPropDescription: description,
      DatabaseTables.colPropLocation: location,
      DatabaseTables.colPropImageUrl: imageUrl,
      DatabaseTables.colPropPrice: price,
      DatabaseTables.colPropBeds: beds,
      DatabaseTables.colPropBaths: baths,
      DatabaseTables.colPropSqft: sqft,
      DatabaseTables.colPropIsAvailable: isAvailable ? 1 : 0,
      DatabaseTables.colPropTags: jsonEncode(tags),
    };
  }

  factory PropertyModel.fromEntity(PropertyEntity entity) {
    return PropertyModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      imageUrl: entity.imageUrl,
      price: entity.price,
      beds: entity.beds,
      baths: entity.baths,
      sqft: entity.sqft,
      isAvailable: entity.isAvailable,
      tags: entity.tags,
    );
  }
}
