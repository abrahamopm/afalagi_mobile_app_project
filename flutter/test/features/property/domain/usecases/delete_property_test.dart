import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/delete_property.dart';

class MockPropertyRepository extends Mock implements PropertyRepository {}

void main() {
  late MockPropertyRepository mockRepository;
  late DeleteProperty usecase;

  setUp(() {
    mockRepository = MockPropertyRepository();
    usecase = DeleteProperty(mockRepository);
  });

  group('DeleteProperty UseCase Tests', () {
    test('should delete property via repository', () async {
      when(() => mockRepository.delete(any())).thenAnswer((_) async => {});

      await usecase('1');

      verify(() => mockRepository.delete('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
