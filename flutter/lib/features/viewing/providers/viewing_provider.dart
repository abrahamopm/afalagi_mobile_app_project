import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/viewing_repository.dart';
import '../models/viewing_model.dart';

final viewingRepositoryProvider = Provider<ViewingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ViewingRepository(dio);
});

class ViewingNotifier extends AsyncNotifier<List<Viewing>> {
  late final ViewingRepository _repository;

  @override
  Future<List<Viewing>> build() async {
    _repository = ref.watch(viewingRepositoryProvider);
    return _repository.getViewings();
  }

  Future<void> addViewing(Viewing viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createViewing(viewing);
      return _repository.getViewings();
    });
  }

  Future<void> updateViewing(String id, Viewing viewing) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateViewing(id, viewing);
      return _repository.getViewings();
    });
  }

  Future<void> deleteViewing(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteViewing(id);
      return _repository.getViewings();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getViewings();
    });
  }
}

final viewingListProvider = AsyncNotifierProvider<ViewingNotifier, List<Viewing>>(() {
  return ViewingNotifier();
});
