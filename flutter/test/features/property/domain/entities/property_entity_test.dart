import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';

void main() {
  const property = PropertyEntity(
    id: '1',
    title: 'Luxury Villa',
    description: 'A beautiful luxury villa by the beach',
    location: 'Miami, FL',
    imageUrl: 'assets/images/villa.png',
    price: 1200000.0,
    beds: 4,
    baths: 3,
    sqft: 3500,
    isAvailable: true,
    tags: ['Beachfront', 'Pool'],
  );

  group('PropertyEntity Tests', () {
    test('supports value equality', () {
      const propertyEquals = PropertyEntity(
        id: '1',
        title: 'Luxury Villa',
        description: 'A beautiful luxury villa by the beach',
        location: 'Miami, FL',
        imageUrl: 'assets/images/villa.png',
        price: 1200000.0,
        beds: 4,
        baths: 3,
        sqft: 3500,
        isAvailable: true,
        tags: ['Beachfront', 'Pool'],
      );

      expect(property, equals(propertyEquals));
    });

    test('supports copyWith', () {
      final updated = property.copyWith(title: 'Super Luxury Villa', price: 1500000.0);

      expect(updated.id, '1');
      expect(updated.title, 'Super Luxury Villa');
      expect(updated.price, 1500000.0);
      expect(updated.beds, 4);
    });

    test('formattedPrice returns correct format', () {
      expect(property.formattedPrice, '1,200,000');
    });
  });
}
