import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/core/database/database_tables.dart';
import 'package:afalagi/features/client/data/models/client_model.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';

void main() {
  const clientModel = ClientModel(
    id: '1',
    name: 'Dawit Mengistu',
    phone: '+251 911 000 000',
    priority: 'VIP',
    interest: 5,
    area: 'Bole',
    budget: '45M – 60M ETB',
    image: 'assets/images/avatar.png',
    tags: ['Penthouse', 'Luxury'],
  );

  group('ClientModel Tests', () {
    test('should be a subclass of ClientEntity', () {
      expect(clientModel, isA<ClientEntity>());
    });

    test('should parse correctly from json', () {
      final json = {
        'id': '1',
        'name': 'Dawit Mengistu',
        'phone': '+251 911 000 000',
        'priority': 'VIP',
        'interest': 5,
        'area': 'Bole',
        'budget': '45M – 60M ETB',
        'image': 'assets/images/avatar.png',
        'tags': ['Penthouse', 'Luxury'],
      };

      final result = ClientModel.fromJson(json);

      expect(result, equals(clientModel));
    });

    test('should serialize correctly to json', () {
      final json = clientModel.toJson();

      final expectedJson = {
        'id': '1',
        'name': 'Dawit Mengistu',
        'phone': '+251 911 000 000',
        'priority': 'VIP',
        'interest': 5,
        'area': 'Bole',
        'budget': '45M – 60M ETB',
        'image': 'assets/images/avatar.png',
        'tags': ['Penthouse', 'Luxury'],
      };

      expect(json, equals(expectedJson));
    });

    test('should parse correctly from map', () {
      final map = {
        DatabaseTables.colClientId: '1',
        DatabaseTables.colClientName: 'Dawit Mengistu',
        DatabaseTables.colClientPhone: '+251 911 000 000',
        DatabaseTables.colClientPriority: 'VIP',
        DatabaseTables.colClientInterest: 5,
        DatabaseTables.colClientArea: 'Bole',
        DatabaseTables.colClientBudget: '45M – 60M ETB',
        DatabaseTables.colClientImage: 'assets/images/avatar.png',
        DatabaseTables.colClientTags: jsonEncode(['Penthouse', 'Luxury']),
      };

      final result = ClientModel.fromMap(map);

      expect(result, equals(clientModel));
    });

    test('should serialize correctly to map', () {
      final map = clientModel.toMap();

      final expectedMap = {
        DatabaseTables.colClientId: '1',
        DatabaseTables.colClientName: 'Dawit Mengistu',
        DatabaseTables.colClientPhone: '+251 911 000 000',
        DatabaseTables.colClientPriority: 'VIP',
        DatabaseTables.colClientInterest: 5,
        DatabaseTables.colClientArea: 'Bole',
        DatabaseTables.colClientBudget: '45M – 60M ETB',
        DatabaseTables.colClientImage: 'assets/images/avatar.png',
        DatabaseTables.colClientTags: jsonEncode(['Penthouse', 'Luxury']),
      };

      expect(map, equals(expectedMap));
    });

    test('should create model from entity correctly', () {
      const entity = ClientEntity(
        id: '1',
        name: 'Dawit Mengistu',
        phone: '+251 911 000 000',
        priority: 'VIP',
        interest: 5,
        area: 'Bole',
        budget: '45M – 60M ETB',
        image: 'assets/images/avatar.png',
        tags: ['Penthouse', 'Luxury'],
      );

      final result = ClientModel.fromEntity(entity);

      expect(result, equals(clientModel));
    });
  });
}
