import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/domain/repositories/client_repository.dart';
import 'package:afalagi/features/client/domain/usecases/get_client_by_id.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  late MockClientRepository mockRepository;
  late GetClientById usecase;

  const tClient = ClientEntity(
    id: '1',
    name: 'Dawit Mengistu',
    phone: '+251 911 000 000',
    priority: 'VIP',
    interest: 5,
    area: 'Bole',
    budget: '45M – 60M ETB',
  );

  setUp(() {
    mockRepository = MockClientRepository();
    usecase = GetClientById(mockRepository);
  });

  group('GetClientById UseCase Tests', () {
    test('should get client by id from repository', () async {
      when(() => mockRepository.getById(any())).thenAnswer((_) async => tClient);

      final result = await usecase('1');

      expect(result, equals(tClient));
      verify(() => mockRepository.getById('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
