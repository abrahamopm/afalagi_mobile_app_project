import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/Core/usecases/usecase.dart';
import '../../../Core/providers/core_providers.dart';
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

final viewingLocalDSProvider = Provider<ViewingLocalDS>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return ViewingLocalDS(dbHelper);
});

final viewingRemoteDSProvider = Provider<ViewingRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return ViewingRemoteDS(dio);
});

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

final getViewingsUseCaseProvider = Provider<GetViewings>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return GetViewings(repository);
});

final createViewingUseCaseProvider = Provider<CreateViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return CreateViewing(repository);
});

final updateViewingUseCaseProvider = Provider<UpdateViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return UpdateViewing(repository);
});

final deleteViewingUseCaseProvider = Provider<DeleteViewing>((ref) {
  final repository = ref.watch(viewingRepositoryProvider);
  return DeleteViewing(repository);
});

class ViewingNotifier extends AsyncNotifier<List<ViewingEntity>> {
  @override
  Future<List<ViewingEntity>> build() async {
    return ref.watch(getViewingsUseCaseProvider).call(const NoParams());
  }

  Future<void> addViewing(ViewingEntity viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = ViewingModel.fromEntity(viewing).toJson();
      await ref.read(createViewingUseCaseProvider).call(body);
      return ref.read(getViewingsUseCaseProvider).call(const NoParams());
    });
  }

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

  Future<void> deleteViewing(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteViewingUseCaseProvider).call(id);
      return ref.read(getViewingsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getViewingsUseCaseProvider).call(const NoParams()),
    );
  }
}

final viewingListProvider =
    AsyncNotifierProvider<ViewingNotifier, List<ViewingEntity>>(
  ViewingNotifier.new,
);
