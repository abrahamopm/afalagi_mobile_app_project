import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/client_local_ds.dart';
import '../data/datasources/client_remote_ds.dart';
import '../data/repositories/client_repository_impl.dart';
import '../domain/repositories/client_repository.dart';
import '../domain/usecases/create_client.dart';
import '../domain/usecases/delete_client.dart';
import '../domain/usecases/get_clients.dart';
import '../domain/usecases/update_client.dart';
import '../models/client_model.dart';

final clientLocalDSProvider = Provider<ClientLocalDS>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return ClientLocalDS(dbHelper);
});

final clientRemoteDSProvider = Provider<ClientRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return ClientRemoteDS(dio);
});

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final remote = ref.watch(clientRemoteDSProvider);
  final local = ref.watch(clientLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ClientRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});

final getClientsUseCaseProvider = Provider<GetClients>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return GetClients(repository);
});

final createClientUseCaseProvider = Provider<CreateClient>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return CreateClient(repository);
});

final updateClientUseCaseProvider = Provider<UpdateClient>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return UpdateClient(repository);
});

final deleteClientUseCaseProvider = Provider<DeleteClient>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return DeleteClient(repository);
});

class ClientNotifier extends AsyncNotifier<List<Client>> {
  @override
  Future<List<Client>> build() async {
    final getClients = ref.watch(getClientsUseCaseProvider);
    final entities = await getClients(NoParams());
    return entities.map((e) => Client(
      id: e.id,
      name: e.name,
      phone: e.phone,
      priority: e.priority,
      interest: e.interest,
      area: e.area,
      budget: e.budget,
      image: e.image,
      tags: e.tags,
    )).toList();
  }

  Future<void> addClient(Client client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createClient = ref.read(createClientUseCaseProvider);
      await createClient(client.toJson()..addAll({'id': client.id}));
      final getClients = ref.read(getClientsUseCaseProvider);
      final entities = await getClients(NoParams());
      return entities.map((e) => Client(
        id: e.id,
        name: e.name,
        phone: e.phone,
        priority: e.priority,
        interest: e.interest,
        area: e.area,
        budget: e.budget,
        image: e.image,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> updateClient(String id, Client client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateClient = ref.read(updateClientUseCaseProvider);
      await updateClient(UpdateClientParams(id: id, body: client.toJson()));
      final getClients = ref.read(getClientsUseCaseProvider);
      final entities = await getClients(NoParams());
      return entities.map((e) => Client(
        id: e.id,
        name: e.name,
        phone: e.phone,
        priority: e.priority,
        interest: e.interest,
        area: e.area,
        budget: e.budget,
        image: e.image,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> deleteClient(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteClient = ref.read(deleteClientUseCaseProvider);
      await deleteClient(id);
      final getClients = ref.read(getClientsUseCaseProvider);
      final entities = await getClients(NoParams());
      return entities.map((e) => Client(
        id: e.id,
        name: e.name,
        phone: e.phone,
        priority: e.priority,
        interest: e.interest,
        area: e.area,
        budget: e.budget,
        image: e.image,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getClients = ref.read(getClientsUseCaseProvider);
      final entities = await getClients(NoParams());
      return entities.map((e) => Client(
        id: e.id,
        name: e.name,
        phone: e.phone,
        priority: e.priority,
        interest: e.interest,
        area: e.area,
        budget: e.budget,
        image: e.image,
        tags: e.tags,
      )).toList();
    });
  }
}

final clientListProvider = AsyncNotifierProvider<ClientNotifier, List<Client>>(() {
  return ClientNotifier();
});
