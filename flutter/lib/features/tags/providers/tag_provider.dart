import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/tag_local_ds.dart';
import '../data/datasources/tag_remote_ds.dart';
import '../data/repositories/tag_repository_impl.dart';
import '../domain/repositories/tag_repository.dart';
import '../domain/usecases/create_tag.dart';
import '../domain/usecases/delete_tag.dart';
import '../domain/usecases/get_tags.dart';
import '../domain/usecases/update_tag.dart';
import '../models/tag_model.dart';

final tagLocalDSProvider = Provider<TagLocalDS>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
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

class TagNotifier extends AsyncNotifier<List<TagModel>> {
  @override
  Future<List<TagModel>> build() async {
    final getTags = ref.watch(getTagsUseCaseProvider);
    final entities = await getTags(NoParams());
    return entities.map((e) => TagModel(
      id: e.id,
      name: e.name,
      color: e.color,
      propertyCount: e.propertyCount,
    )).toList();
  }

  Future<void> addTag(TagModel tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final createTag = ref.read(createTagUseCaseProvider);
      await createTag(tag.toJson()..addAll({'id': tag.id}));
      final getTags = ref.read(getTagsUseCaseProvider);
      final entities = await getTags(NoParams());
      return entities.map((e) => TagModel(
        id: e.id,
        name: e.name,
        color: e.color,
        propertyCount: e.propertyCount,
      )).toList();
    });
  }

  Future<void> updateTag(String id, TagModel tag) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateTag = ref.read(updateTagUseCaseProvider);
      await updateTag(UpdateTagParams(id: id, body: tag.toJson()));
      final getTags = ref.read(getTagsUseCaseProvider);
      final entities = await getTags(NoParams());
      return entities.map((e) => TagModel(
        id: e.id,
        name: e.name,
        color: e.color,
        propertyCount: e.propertyCount,
      )).toList();
    });
  }

  Future<void> deleteTag(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteTag = ref.read(deleteTagUseCaseProvider);
      await deleteTag(id);
      final getTags = ref.read(getTagsUseCaseProvider);
      final entities = await getTags(NoParams());
      return entities.map((e) => TagModel(
        id: e.id,
        name: e.name,
        color: e.color,
        propertyCount: e.propertyCount,
      )).toList();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getTags = ref.read(getTagsUseCaseProvider);
      final entities = await getTags(NoParams());
      return entities.map((e) => TagModel(
        id: e.id,
        name: e.name,
        color: e.color,
        propertyCount: e.propertyCount,
      )).toList();
    });
  }
}

final tagListProvider = AsyncNotifierProvider<TagNotifier, List<TagModel>>(() {
  return TagNotifier();
});
