import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/property_repository.dart';
import '../models/property_model.dart';

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PropertyRepository(dio);
});

class PropertyNotifier extends AsyncNotifier<List<Property>> {
  late final PropertyRepository _repository;

  @override
  Future<List<Property>> build() async {
    _repository = ref.watch(propertyRepositoryProvider);
    return _repository.getProperties();
  }

  Future<void> addProperty(Property property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createProperty(property);
      return _repository.getProperties();
    });
  }

  Future<void> updateProperty(String id, Property property) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateProperty(id, property);
      return _repository.getProperties();
    });
  }

  Future<void> deleteProperty(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteProperty(id);
      return _repository.getProperties();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getProperties();
    });
  }
}

final propertyListProvider = AsyncNotifierProvider<PropertyNotifier, List<Property>>(() {
  return PropertyNotifier();
});
