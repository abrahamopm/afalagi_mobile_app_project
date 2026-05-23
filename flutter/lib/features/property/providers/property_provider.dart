import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/property_local_ds.dart';
import '../data/datasources/property_remote_ds.dart';
import '../data/models/property_model.dart';
import '../data/repositories/property_repository_impl.dart';
import '../domain/entities/property_entity.dart';
import '../domain/repositories/property_repository.dart';
import '../domain/usecases/create_property.dart';
import '../domain/usecases/delete_property.dart';
import '../domain/usecases/get_properties.dart';
import '../domain/usecases/get_property_by_id.dart';
import '../domain/usecases/update_property.dart';

final propertyLocalDSProvider = Provider<PropertyLocalDS>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return PropertyLocalDS(dbHelper);
});

final propertyRemoteDSProvider = Provider<PropertyRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return PropertyRemoteDS(dio);
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final remote = ref.watch(propertyRemoteDSProvider);
  final local = ref.watch(propertyLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return PropertyRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});

final getPropertiesUseCaseProvider = Provider<GetProperties>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return GetProperties(repository);
});

final getPropertyByIdUseCaseProvider = Provider<GetPropertyById>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return GetPropertyById(repository);
});

final createPropertyUseCaseProvider = Provider<CreateProperty>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return CreateProperty(repository);
});

final updatePropertyUseCaseProvider = Provider<UpdateProperty>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return UpdateProperty(repository);
});

final deletePropertyUseCaseProvider = Provider<DeleteProperty>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return DeleteProperty(repository);
});

class PropertyNotifier extends AsyncNotifier<List<PropertyEntity>> {
  @override
  Future<List<PropertyEntity>> build() async {
    return ref.watch(getPropertiesUseCaseProvider).call(const NoParams());
  }

  Future<void> addProperty(PropertyEntity property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = PropertyModel.fromEntity(property).toJson();
      await ref.read(createPropertyUseCaseProvider).call(body);
      return ref.read(getPropertiesUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> updateProperty(String id, PropertyEntity property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = PropertyModel.fromEntity(property).toJson();
      await ref.read(updatePropertyUseCaseProvider).call(
        UpdatePropertyParams(id: id, body: body),
      );
      return ref.read(getPropertiesUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> deleteProperty(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deletePropertyUseCaseProvider).call(id);
      return ref.read(getPropertiesUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getPropertiesUseCaseProvider).call(const NoParams()),
    );
  }
}

final propertyListProvider =
    AsyncNotifierProvider<PropertyNotifier, List<PropertyEntity>>(
  PropertyNotifier.new,
);
