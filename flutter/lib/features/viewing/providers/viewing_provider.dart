import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasources/viewing_local_ds.dart';
import '../data/datasources/viewing_remote_ds.dart';
import '../data/models/viewing_model.dart';
import '../data/repositories/viewing_repository_impl.dart';
import '../domain/entities/viewing_entity.dart';
import '../domain/repositories/viewing_repository.dart';
import '../domain/usecases/create_viewing.dart';
import '../domain/usecases/delete_viewing.dart';
import '../domain/usecases/get_viewings.dart';
import '../domain/usecases/update_viewing.dart';

// Providers for Viewing feature
final viewingLocalDSProvider = Provider<ViewingLocalDS>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return ViewingLocalDS(dbHelper);
});

// Remote DS provider is defined in core providers since it requires dio, but we can also define it here if we want to keep it feature-specific
final viewingRemoteDSProvider = Provider<ViewingRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return ViewingRemoteDS(dio);
});

// Repository provider that combines local and remote data sources
final viewingRepositoryProvider = Provider<ViewingRepository>((ref) {
  final remote = ref.watch(viewingRemoteDSProvider);
  final local = ref.watch(viewingLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ViewingRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});


// Use case providers
// Get viewings use case provider
final getViewingsUseCaseProvider = Provider<GetViewings>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return GetViewings(repository);
});

// Create viewing use case provider
final createViewingUseCaseProvider = Provider<CreateViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return CreateViewing(repository);
});

// Update use case provider
final updateViewingUseCaseProvider = Provider<UpdateViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return UpdateViewing(repository);
});

//delete use case provider
final deleteViewingUseCaseProvider = Provider<DeleteViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return DeleteViewing(repository);
});

// ViewingNotifier to manage state of viewings in the UI
class ViewingNotifier extends AsyncNotifier<List<ViewingEntity>> {
  @override
  Future<List<ViewingEntity>> build() async {
    return ref.watch(getViewingsUseCaseProvider).call(const NoParams());
  }
// Methods to add, update, delete viewings
  Future<void> addViewing(ViewingEntity viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = ViewingModel.fromEntity(viewing).toJson();
      await ref.read(createViewingUseCaseProvider).call(body);
      return ref.read(getViewingsUseCaseProvider).call(const NoParams());
    });
  }
// Update method
  Future<void> updateViewing(String id, ViewingEntity viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = ViewingModel.fromEntity(viewing).toJson();
      await ref.read(updateViewingUseCaseProvider).call(
        UpdateViewingParams(id: id, body: body),
      );
      return ref.read(getViewingsUseCaseProvider).call(const NoParams());
    });
  }
// Delete method
  Future<void> deleteViewing(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteViewingUseCaseProvider).call(id);
      return ref.read(getViewingsUseCaseProvider).call(const NoParams());
    });
  }
// Refresh method to re-fetch viewings from the server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getViewingsUseCaseProvider).call(const NoParams()),
    );
  }
}
// Provider for ViewingNotifier
final viewingListProvider =
    AsyncNotifierProvider<ViewingNotifier, List<ViewingEntity>>(
  ViewingNotifier.new,
);
