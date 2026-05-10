import 'package:afalagi/features/property/models/property_model.dart';

class PropertyService {
  static final List<Property> _properties = [
    Property(
      id: '1',
      title: 'Luxury Villa',
      location: 'Beachfront',
      imageUrl: 'assets/images/luxury_villa.png',
      description: 'A beautiful beachfront villa with stunning views.',
      price: 1000000,
      beds: 4,
      baths: 3,
      sqft: 2500,
    ),
    Property(
      id: '2',
      title: 'Modern Apartment',
      location: 'City Center',
      imageUrl: 'assets/images/modern_apartment.png',
      description: 'A modern apartment in heart of city.',
      price: 500000,
      beds: 2,
      baths: 2,
      sqft: 1200,
    ),
  ];

  static List<Property> getProperties() {
    return _properties;
  }

  static void addProperty(Property property) {
    _properties.insert(0, property);
  }

  static void updateProperty(Property updatedProperty) {
    final index = _properties.indexWhere((p) => p.id == updatedProperty.id);
    if (index != -1) {
      _properties[index] = updatedProperty;
    }
  }

  static void deleteProperty(String id) {
    _properties.removeWhere((p) => p.id == id);
  }
}
