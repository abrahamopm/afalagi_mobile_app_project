import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/create_property.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockPropertyRepository mockRepository;
  late CreateProperty usecase;

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
    usecase = CreateProperty(mockRepository);
  });

  group('CreateProperty UseCase Tests', () {
    test('should create property via repository', () async {
      final body = {'title': 'Test Property'};
      when(() => mockRepository.create(any())).thenAnswer((_) async => tProperty);

      final result = await usecase(body);

      expect(result, equals(tProperty));
      verify(() => mockRepository.create(body)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
