import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';

void main() {
  const tTag = TagEntity(
    id: '1',
    name: 'Luxury',
    color: '#1B385E',
    propertyCount: 3,
  );

  group('TagEntity', () {
    test('supports value equality', () {
      expect(
        const TagEntity(id: '1', name: 'Luxury', color: '#1B385E', propertyCount: 3),
        tTag,
      );
    });

    test('supports copyWith', () {
      expect(tTag.copyWith(name: 'Premium'), const TagEntity(
        id: '1',
        name: 'Premium',
        color: '#1B385E',
        propertyCount: 3,
      ));
    });
  });
}
