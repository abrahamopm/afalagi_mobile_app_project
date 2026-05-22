import 'dart:convert';
import '../../domain/entities/client_entity.dart';
import '../../../../core/database/database_tables.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
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

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
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
      'id': id,
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

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    List<String> tagsList = [];
    try {
      if (map[DatabaseTables.colClientTags] != null) {
        tagsList = List<String>.from(jsonDecode(map[DatabaseTables.colClientTags] as String));
      }
    } catch (_) {}

    return ClientModel(
      id: map[DatabaseTables.colClientId] ?? '',
      name: map[DatabaseTables.colClientName] ?? '',
      phone: map[DatabaseTables.colClientPhone] ?? '',
      priority: map[DatabaseTables.colClientPriority] ?? 'MODERATE',
      interest: map[DatabaseTables.colClientInterest] ?? 3,
      area: map[DatabaseTables.colClientArea] ?? '',
      budget: map[DatabaseTables.colClientBudget] ?? '',
      image: map[DatabaseTables.colClientImage] ?? '',
      tags: tagsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseTables.colClientId: id,
      DatabaseTables.colClientName: name,
      DatabaseTables.colClientPhone: phone,
      DatabaseTables.colClientPriority: priority,
      DatabaseTables.colClientInterest: interest,
      DatabaseTables.colClientArea: area,
      DatabaseTables.colClientBudget: budget,
      DatabaseTables.colClientImage: image,
      DatabaseTables.colClientTags: jsonEncode(tags),
    };
  }

  factory ClientModel.fromEntity(ClientEntity entity) {
    return ClientModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      priority: entity.priority,
      interest: entity.interest,
      area: entity.area,
      budget: entity.budget,
      image: entity.image,
      tags: entity.tags,
    );
  }
}
