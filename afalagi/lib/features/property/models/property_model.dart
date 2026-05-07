import 'package:afalagi/core/util/format.dart';

class Property {
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

  Property({
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
  });

  // Helper to format price with commas (e.g., 1,890,000)
  String get formattedPrice {
    return FormatNumber.price(price);
  }

  // For API fetch later
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      beds: json['beds'],
      baths: json['baths'],
      sqft: json['sqft'],
      description: json['description'] ?? 'No description available',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
