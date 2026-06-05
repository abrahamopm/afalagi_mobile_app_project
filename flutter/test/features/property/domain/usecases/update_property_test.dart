import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/update_property.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const UpdatePropertyParams(id: '', body: {}));
  });

  late MockPropertyRepository mockRepository;
  late UpdateProperty usecase;

  const tProperty = PropertyEntity(
    id: '1',
    title: 'Updated Property',
    description: 'Test Description',
    location: 'Test Location',
    imageUrl: 'test.png',
    price: 1000.0,
    beds: 1,
    baths: 1,
    sqft: 100,
    isAvailable: true,
    tags: [],
  );

  setUp(() {
    mockRepository = MockPropertyRepository();
    usecase = UpdateProperty(mockRepository);
  });

  group('UpdateProperty UseCase Tests', () {
    test('should update property via repository', () async {
      const params = UpdatePropertyParams(
        id: '1',
        body: {'title': 'Updated Property'},
      );
      when(() => mockRepository.update(any(), any())).thenAnswer((_) async => tProperty);

      final result = await usecase(params);

      expect(result, equals(tProperty));
      verify(() => mockRepository.update('1', params.body)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
