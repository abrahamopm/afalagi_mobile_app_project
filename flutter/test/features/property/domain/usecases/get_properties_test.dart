import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/get_properties.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  late MockPropertyRepository mockRepository;
  late GetProperties usecase;

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

  final tPropertyList = [tProperty];

  setUp(() {
    mockRepository = MockPropertyRepository();
    usecase = GetProperties(mockRepository);
  });

  group('GetProperties UseCase Tests', () {
    test('should get properties from repository', () async {
      // arrange
      when(() => mockRepository.getAll()).thenAnswer((_) async => tPropertyList);

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(tPropertyList));
      verify(() => mockRepository.getAll()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
