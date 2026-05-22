import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/property_local_ds.dart';
import '../data/datasources/property_remote_ds.dart';
import '../data/repositories/property_repository_impl.dart';
import '../domain/repositories/property_repository.dart';
import '../domain/usecases/create_property.dart';
import '../domain/usecases/delete_property.dart';
import '../domain/usecases/get_properties.dart';
import '../domain/usecases/get_property_by_id.dart';
import '../domain/usecases/update_property.dart';
import '../models/property_model.dart';

final propertyLocalDSProvider = Provider<PropertyLocalDS>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
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

class PropertyNotifier extends AsyncNotifier<List<Property>> {
  @override
  Future<List<Property>> build() async {
    final getProperties = ref.watch(getPropertiesUseCaseProvider);
    final entities = await getProperties(NoParams());
    return entities.map((e) => Property(
      id: e.id,
      title: e.title,
      description: e.description,
      location: e.location,
      imageUrl: e.imageUrl,
      price: e.price,
      beds: e.beds,
      baths: e.baths,
      sqft: e.sqft,
      isAvailable: e.isAvailable,
      tags: e.tags,
    )).toList();
  }

  Future<void> addProperty(Property property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createProperty = ref.read(createPropertyUseCaseProvider);
      await createProperty(property.toJson()..addAll({'id': property.id}));
      final getProperties = ref.read(getPropertiesUseCaseProvider);
      final entities = await getProperties(NoParams());
      return entities.map((e) => Property(
        id: e.id,
        title: e.title,
        description: e.description,
        location: e.location,
        imageUrl: e.imageUrl,
        price: e.price,
        beds: e.beds,
        baths: e.baths,
        sqft: e.sqft,
        isAvailable: e.isAvailable,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> updateProperty(String id, Property property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateProperty = ref.read(updatePropertyUseCaseProvider);
      await updateProperty(UpdatePropertyParams(id: id, body: property.toJson()));
      final getProperties = ref.read(getPropertiesUseCaseProvider);
      final entities = await getProperties(NoParams());
      return entities.map((e) => Property(
        id: e.id,
        title: e.title,
        description: e.description,
        location: e.location,
        imageUrl: e.imageUrl,
        price: e.price,
        beds: e.beds,
        baths: e.baths,
        sqft: e.sqft,
        isAvailable: e.isAvailable,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> deleteProperty(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteProperty = ref.read(deletePropertyUseCaseProvider);
      await deleteProperty(id);
      final getProperties = ref.read(getPropertiesUseCaseProvider);
      final entities = await getProperties(NoParams());
      return entities.map((e) => Property(
        id: e.id,
        title: e.title,
        description: e.description,
        location: e.location,
        imageUrl: e.imageUrl,
        price: e.price,
        beds: e.beds,
        baths: e.baths,
        sqft: e.sqft,
        isAvailable: e.isAvailable,
        tags: e.tags,
      )).toList();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getProperties = ref.read(getPropertiesUseCaseProvider);
      final entities = await getProperties(NoParams());
      return entities.map((e) => Property(
        id: e.id,
        title: e.title,
        description: e.description,
        location: e.location,
        imageUrl: e.imageUrl,
        price: e.price,
        beds: e.beds,
        baths: e.baths,
        sqft: e.sqft,
        isAvailable: e.isAvailable,
        tags: e.tags,
      )).toList();
    });
  }
}

final propertyListProvider = AsyncNotifierProvider<PropertyNotifier, List<Property>>(() {
  return PropertyNotifier();
});
