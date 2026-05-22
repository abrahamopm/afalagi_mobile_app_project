import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/viewing_local_ds.dart';
import '../data/datasources/viewing_remote_ds.dart';
import '../data/repositories/viewing_repository_impl.dart';
import '../domain/repositories/viewing_repository.dart';
import '../domain/usecases/create_viewing.dart';
import '../domain/usecases/delete_viewing.dart';
import '../domain/usecases/get_viewings.dart';
import '../domain/usecases/update_viewing.dart';
import '../models/viewing_model.dart';

final viewingLocalDSProvider = Provider<ViewingLocalDS>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
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

class ViewingNotifier extends AsyncNotifier<List<Viewing>> {
  @override
  Future<List<Viewing>> build() async {
    final getViewings = ref.watch(getViewingsUseCaseProvider);
    final entities = await getViewings(NoParams());
    return entities.map((e) => Viewing(
      id: e.id,
      propertyId: e.propertyId,
      clientId: e.clientId,
      propertyTitle: e.propertyTitle,
      clientName: e.clientName,
      imageUrl: e.imageUrl,
      date: e.date,
      status: e.status,
      price: e.price,
      notes: e.notes,
    )).toList();
  }

  Future<void> addViewing(Viewing viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createViewing = ref.read(createViewingUseCaseProvider);
      await createViewing(viewing.toJson()..addAll({'id': viewing.id}));
      final getViewings = ref.read(getViewingsUseCaseProvider);
      final entities = await getViewings(NoParams());
      return entities.map((e) => Viewing(
        id: e.id,
        propertyId: e.propertyId,
        clientId: e.clientId,
        propertyTitle: e.propertyTitle,
        clientName: e.clientName,
        imageUrl: e.imageUrl,
        date: e.date,
        status: e.status,
        price: e.price,
        notes: e.notes,
      )).toList();
    });
  }

  Future<void> updateViewing(String id, Viewing viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateViewing = ref.read(updateViewingUseCaseProvider);
      await updateViewing(UpdateViewingParams(id: id, body: viewing.toJson()));
      final getViewings = ref.read(getViewingsUseCaseProvider);
      final entities = await getViewings(NoParams());
      return entities.map((e) => Viewing(
        id: e.id,
        propertyId: e.propertyId,
        clientId: e.clientId,
        propertyTitle: e.propertyTitle,
        clientName: e.clientName,
        imageUrl: e.imageUrl,
        date: e.date,
        status: e.status,
        price: e.price,
        notes: e.notes,
      )).toList();
    });
  }

  Future<void> deleteViewing(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteViewing = ref.read(deleteViewingUseCaseProvider);
      await deleteViewing(id);
      final getViewings = ref.read(getViewingsUseCaseProvider);
      final entities = await getViewings(NoParams());
      return entities.map((e) => Viewing(
        id: e.id,
        propertyId: e.propertyId,
        clientId: e.clientId,
        propertyTitle: e.propertyTitle,
        clientName: e.clientName,
        imageUrl: e.imageUrl,
        date: e.date,
        status: e.status,
        price: e.price,
        notes: e.notes,
      )).toList();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getViewings = ref.read(getViewingsUseCaseProvider);
      final entities = await getViewings(NoParams());
      return entities.map((e) => Viewing(
        id: e.id,
        propertyId: e.propertyId,
        clientId: e.clientId,
        propertyTitle: e.propertyTitle,
        clientName: e.clientName,
        imageUrl: e.imageUrl,
        date: e.date,
        status: e.status,
        price: e.price,
        notes: e.notes,
      )).toList();
    });
  }
}

final viewingListProvider = AsyncNotifierProvider<ViewingNotifier, List<Viewing>>(() {
  return ViewingNotifier();
});
