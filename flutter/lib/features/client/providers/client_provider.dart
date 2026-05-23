import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/client_local_ds.dart';
import '../data/datasources/client_remote_ds.dart';
import '../data/models/client_model.dart';
import '../data/repositories/client_repository_impl.dart';
import '../domain/entities/client_entity.dart';
import '../domain/repositories/client_repository.dart';
import '../domain/usecases/create_client.dart';
import '../domain/usecases/delete_client.dart';
import '../domain/usecases/get_clients.dart';
import '../domain/usecases/update_client.dart';

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

class ClientNotifier extends AsyncNotifier<List<ClientEntity>> {
  @override
  Future<List<ClientEntity>> build() async {
    return ref.watch(getClientsUseCaseProvider).call(const NoParams());
  }

  Future<void> addClient(ClientEntity client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = ClientModel.fromEntity(client).toJson();
      await ref.read(createClientUseCaseProvider).call(body);
      return ref.read(getClientsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> updateClient(String id, ClientEntity client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = ClientModel.fromEntity(client).toJson();
      await ref.read(updateClientUseCaseProvider).call(
        UpdateClientParams(id: id, body: body),
      );
      return ref.read(getClientsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> deleteClient(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteClientUseCaseProvider).call(id);
      return ref.read(getClientsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getClientsUseCaseProvider).call(const NoParams()),
    );
  }
}

final clientListProvider =
    AsyncNotifierProvider<ClientNotifier, List<ClientEntity>>(
  ClientNotifier.new,
);
