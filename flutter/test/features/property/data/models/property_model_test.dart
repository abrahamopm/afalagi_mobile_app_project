import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/features/property/data/models/property_model.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/Core/database/database_tables.dart';

void main() {
  const propertyModel = PropertyModel(
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

  group('PropertyModel Tests', () {
    test('should be a subclass of PropertyEntity', () {
      expect(propertyModel, isA<PropertyEntity>());
    });

    test('should parse correctly from json', () {
      final json = {
        'id': '1',
        'title': 'Luxury Villa',
        'description': 'A beautiful luxury villa by the beach',
        'location': 'Miami, FL',
        'imageUrl': 'assets/images/villa.png',
        'price': 1200000.0,
        'beds': 4,
        'baths': 3,
        'sqft': 3500,
        'isAvailable': true,
        'tags': ['Beachfront', 'Pool'],
      };

      final result = PropertyModel.fromJson(json);

      expect(result, equals(propertyModel));
    });

    test('should serialize correctly to json', () {
      final json = propertyModel.toJson();

      final expectedJson = {
        'id': '1',
        'title': 'Luxury Villa',
        'description': 'A beautiful luxury villa by the beach',
        'location': 'Miami, FL',
        'imageUrl': 'assets/images/villa.png',
        'price': 1200000.0,
        'beds': 4,
        'baths': 3,
        'sqft': 3500,
        'isAvailable': true,
        'tags': ['Beachfront', 'Pool'],
      };

      expect(json, equals(expectedJson));
    });

    test('should parse correctly from map', () {
      final map = {
        DatabaseTables.colPropId: '1',
        DatabaseTables.colPropTitle: 'Luxury Villa',
        DatabaseTables.colPropDescription: 'A beautiful luxury villa by the beach',
        DatabaseTables.colPropLocation: 'Miami, FL',
        DatabaseTables.colPropImageUrl: 'assets/images/villa.png',
        DatabaseTables.colPropPrice: 1200000.0,
        DatabaseTables.colPropBeds: 4,
        DatabaseTables.colPropBaths: 3,
        DatabaseTables.colPropSqft: 3500,
        DatabaseTables.colPropIsAvailable: 1,
        DatabaseTables.colPropTags: jsonEncode(['Beachfront', 'Pool']),
      };

      final result = PropertyModel.fromMap(map);

      expect(result, equals(propertyModel));
    });

    test('should serialize correctly to map', () {
      final map = propertyModel.toMap();

      final expectedMap = {
        DatabaseTables.colPropId: '1',
        DatabaseTables.colPropTitle: 'Luxury Villa',
        DatabaseTables.colPropDescription: 'A beautiful luxury villa by the beach',
        DatabaseTables.colPropLocation: 'Miami, FL',
        DatabaseTables.colPropImageUrl: 'assets/images/villa.png',
        DatabaseTables.colPropPrice: 1200000.0,
        DatabaseTables.colPropBeds: 4,
        DatabaseTables.colPropBaths: 3,
        DatabaseTables.colPropSqft: 3500,
        DatabaseTables.colPropIsAvailable: 1,
        DatabaseTables.colPropTags: jsonEncode(['Beachfront', 'Pool']),
      };

      expect(map, equals(expectedMap));
    });

    test('should create model from entity correctly', () {
      const entity = PropertyEntity(
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

      final result = PropertyModel.fromEntity(entity);

      expect(result, equals(propertyModel));
    });
  });
}
