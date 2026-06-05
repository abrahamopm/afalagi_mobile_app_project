import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/domain/repositories/client_repository.dart';
import 'package:afalagi/features/client/domain/usecases/get_clients.dart';

class MockClientRepository extends Mock implements ClientRepository {}

void main() {
  late MockClientRepository mockRepository;
  late GetClients usecase;

  const tClient = ClientEntity(
    id: '1',
    name: 'Dawit Mengistu',
    phone: '+251 911 000 000',
    priority: 'VIP',
    interest: 5,
    area: 'Bole',
    budget: '45M – 60M ETB',
  );

  final tClientList = [tClient];

  setUp(() {
    mockRepository = MockClientRepository();
    usecase = GetClients(mockRepository);
  });

  group('GetClients UseCase Tests', () {
    test('should get clients from repository', () async {
      when(() => mockRepository.getAll()).thenAnswer((_) async => tClientList);

      final result = await usecase(const NoParams());

      expect(result, equals(tClientList));
      verify(() => mockRepository.getAll()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
