import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasources/tag_local_ds.dart';
import '../data/datasources/tag_remote_ds.dart';
import '../data/models/tag_model.dart';
import '../data/repositories/tag_repository_impl.dart';
import '../domain/entities/tag_entity.dart';
import '../domain/repositories/tag_repository.dart';
import '../domain/usecases/create_tag.dart';
import '../domain/usecases/delete_tag.dart';
import '../domain/usecases/get_tags.dart';
import '../domain/usecases/update_tag.dart';

final tagLocalDSProvider = Provider<TagLocalDS>((ref) {
  final dbHelper = ref.watch(databaseProvider);
  return TagLocalDS(dbHelper);
});

final tagRemoteDSProvider = Provider<TagRemoteDS>((ref) {
  final dio = ref.watch(dioProvider);
  return TagRemoteDS(dio);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final remote = ref.watch(tagRemoteDSProvider);
  final local = ref.watch(tagLocalDSProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return TagRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});

final getTagsUseCaseProvider = Provider<GetTags>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return GetTags(repository);
});

final createTagUseCaseProvider = Provider<CreateTag>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return CreateTag(repository);
});

final updateTagUseCaseProvider = Provider<UpdateTag>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return UpdateTag(repository);
});

final deleteTagUseCaseProvider = Provider<DeleteTag>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return DeleteTag(repository);
});

class TagNotifier extends AsyncNotifier<List<TagEntity>> {
  @override
  Future<List<TagEntity>> build() async {
    return ref.watch(getTagsUseCaseProvider).call(const NoParams());
  }

  Future<void> addTag(TagEntity tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = TagModel.fromEntity(tag).toJson();
      await ref.read(createTagUseCaseProvider).call(body);
      return ref.read(getTagsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> updateTag(String id, TagEntity tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final body = TagModel.fromEntity(tag).toJson();
      await ref.read(updateTagUseCaseProvider).call(
        UpdateTagParams(id: id, body: body),
      );
      return ref.read(getTagsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> deleteTag(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteTagUseCaseProvider).call(id);
      return ref.read(getTagsUseCaseProvider).call(const NoParams());
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getTagsUseCaseProvider).call(const NoParams()),
    );
  }
}

final tagListProvider =
    AsyncNotifierProvider<TagNotifier, List<TagEntity>>(
  TagNotifier.new,
);
