import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/get_property_by_id.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  late MockPropertyRepository mockRepository;
  late GetPropertyById usecase;

  const tProperty = PropertyEntity(
    id: '1',
    title: 'Test Property',
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
    usecase = GetPropertyById(mockRepository);
  });

  group('GetPropertyById UseCase Tests', () {
    test('should get property by id from repository', () async {
      when(() => mockRepository.getById(any())).thenAnswer((_) async => tProperty);

      final result = await usecase('1');

      expect(result, equals(tProperty));
      verify(() => mockRepository.getById('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
