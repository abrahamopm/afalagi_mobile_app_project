import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/domain/repositories/client_repository.dart';
import 'package:afalagi/features/client/domain/usecases/get_clients.dart';
import 'package:afalagi/features/client/providers/client_provider.dart';

class DummyClientRepository implements ClientRepository {
  final List<ClientEntity> list;

  DummyClientRepository(this.list);

  @override
  Future<List<ClientEntity>> getAll() async => list;

  @override
  Future<ClientEntity> getById(String id) async => throw UnimplementedError();

  @override
  Future<ClientEntity> create(Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<ClientEntity> update(String id, Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

void main() {
  test('clientListProvider returns list from overridden usecase', () async {
    const tEntity = ClientEntity(
      id: '1',
      name: 'Dawit Mengistu',
      phone: '+251 911 000 000',
      priority: 'VIP',
      interest: 5,
      area: 'Bole',
      budget: '45M – 60M ETB',
    );

    final tList = [tEntity];
    final testGetClients = GetClients(DummyClientRepository(tList));

    final container = ProviderContainer(
      overrides: [
        getClientsUseCaseProvider.overrideWithValue(testGetClients),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(clientListProvider.future);

    expect(result, equals(tList));
  });
}
