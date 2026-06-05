import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/core/database/database_tables.dart';
import 'package:afalagi/features/tags/data/models/tag_model.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';

void main() {
  const tTagModel = TagModel(
    id: '1',
    name: 'Luxury',
    color: '#1B385E',
    propertyCount: 2,
  );

  group('TagModel', () {
    test('should be a subclass of TagEntity', () {
      expect(tTagModel, isA<TagEntity>());
    });

    test('should parse correctly from json', () {
      final model = TagModel.fromJson({
        '_id': '1',
        'name': 'Luxury',
        'color': '#1B385E',
        'propertyCount': 2,
      });
      expect(model, tTagModel);
    });

    test('should serialize correctly to json', () {
      expect(tTagModel.toJson(), {'name': 'Luxury', 'color': '#1B385E'});
    });

    test('should parse correctly from map', () {
      final model = TagModel.fromMap({
        DatabaseTables.colTagId: '1',
        DatabaseTables.colTagName: 'Luxury',
        DatabaseTables.colTagColor: '#1B385E',
        DatabaseTables.colTagPropertyCount: 2,
      });
      expect(model, tTagModel);
    });

    test('should serialize correctly to map', () {
      expect(tTagModel.toMap(), {
        DatabaseTables.colTagId: '1',
        DatabaseTables.colTagName: 'Luxury',
        DatabaseTables.colTagColor: '#1B385E',
        DatabaseTables.colTagPropertyCount: 2,
      });
    });

    test('should create model from entity correctly', () {
      const entity = TagEntity(id: '1', name: 'Luxury', color: '#1B385E', propertyCount: 2);
      expect(TagModel.fromEntity(entity), tTagModel);
    });
  });
}
