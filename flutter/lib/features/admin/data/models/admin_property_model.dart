import '../../domain/entities/admin_property_item.dart';

class AdminPropertyModel extends AdminPropertyItem {
  const AdminPropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.imageUrl,
    required super.price,
    required super.beds,
    required super.baths,
    required super.sqft,
    required super.isAvailable,
    required super.tags,
    required super.agentName,
    super.agentEmail,
  });

  factory AdminPropertyModel.fromJson(Map<String, dynamic> json) {
    return AdminPropertyModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/generic_property.png',
      price: (json['price'] ?? 0).toDouble(),
      beds: json['beds'] ?? 0,
      baths: json['baths'] ?? 0,
      sqft: json['sqft'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
      agentName: json['agentName'] ?? 'Unknown Agent',
      agentEmail: json['agentEmail'] ?? '',
    );
  }
}
