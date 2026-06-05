import 'package:afalagi/core/util/format.dart';

class PropertyEntity {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final double price;
  final int beds;
  final int baths;
  final int sqft;
  final bool isAvailable;
  final List<String> tags;

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.beds,
    required this.baths,
    required this.sqft,
    this.isAvailable = true,
    this.tags = const [],
  });

  String get formattedPrice {
    return FormatNumber.price(price);
  }

  PropertyEntity copyWith({
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
    return PropertyEntity(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          location == other.location &&
          imageUrl == other.imageUrl &&
          price == other.price &&
          beds == other.beds &&
          baths == other.baths &&
          sqft == other.sqft &&
          isAvailable == other.isAvailable &&
          tags.toString() == other.tags.toString();

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      location.hashCode ^
      imageUrl.hashCode ^
      price.hashCode ^
      beds.hashCode ^
      baths.hashCode ^
      sqft.hashCode ^
      isAvailable.hashCode ^
      tags.toString().hashCode;
}
