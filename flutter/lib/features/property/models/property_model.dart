import '../../domain/entities/property_entity.dart';
import '../../../../core/util/format.dart';

class Property extends PropertyEntity {
  const Property({
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

  String get formattedPrice {
    return FormatNumber.price(price);
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/generic_property.png',
      price: (json['price'] ?? 0).toDouble(),
      beds: json['beds'] ?? 0,
      baths: json['baths'] ?? 0,
      sqft: json['sqft'] ?? 0,
      description: json['description'] ?? 'No description available',
      isAvailable: json['isAvailable'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  Property copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? imageUrl,
    double? price,
    int? beds,
    int? baths,
    int? sqft,
    bool? isAvailable,
    List<String>? tags,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      beds: beds ?? this.beds,
      baths: baths ?? this.baths,
      sqft: sqft ?? this.sqft,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
    );
  }
}
