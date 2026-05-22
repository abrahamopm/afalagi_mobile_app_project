import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/tag_repository.dart';
import '../models/tag_model.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TagRepository(dio);
});

class TagNotifier extends AsyncNotifier<List<TagModel>> {
  late final TagRepository _repository;

  @override
  Future<List<TagModel>> build() async {
    _repository = ref.watch(tagRepositoryProvider);
    return _repository.getTags();
  }

  Future<void> addTag(TagModel tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createTag(tag);
      return _repository.getTags();
    });
  }

  Future<void> updateTag(String id, TagModel tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateTag(id, tag);
      return _repository.getTags();
    });
  }

  Future<void> deleteTag(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteTag(id);
      return _repository.getTags();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getTags();
    });
  }
}

final tagListProvider = AsyncNotifierProvider<TagNotifier, List<TagModel>>(() {
  return TagNotifier();
});
