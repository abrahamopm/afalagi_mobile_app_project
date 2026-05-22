import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/client_repository.dart';
import '../models/client_model.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ClientRepository(dio);
});

class ClientNotifier extends AsyncNotifier<List<Client>> {
  late final ClientRepository _repository;

  @override
  Future<List<Client>> build() async {
    _repository = ref.watch(clientRepositoryProvider);
    return _repository.getClients();
  }

  Future<void> addClient(Client client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createClient(client);
      return _repository.getClients();
    });
  }

  Future<void> updateClient(String id, Client client) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateClient(id, client);
      return _repository.getClients();
    });
  }

  Future<void> deleteClient(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteClient(id);
      return _repository.getClients();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getClients();
    });
  }
}

final clientListProvider = AsyncNotifierProvider<ClientNotifier, List<Client>>(() {
  return ClientNotifier();
});
