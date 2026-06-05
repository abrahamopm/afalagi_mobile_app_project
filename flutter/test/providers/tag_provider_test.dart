import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/get_tags.dart';
import 'package:afalagi/features/tags/providers/tag_provider.dart';

class DummyTagRepository implements TagRepository {
  final List<TagEntity> list;

  DummyTagRepository(this.list);

  @override
  Future<List<TagEntity>> getAll() async => list;

  @override
  Future<TagEntity> getById(String id) async => throw UnimplementedError();

  @override
  Future<TagEntity> create(Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<TagEntity> update(String id, Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

void main() {
  test('tagListProvider returns tags from overridden usecase', () async {
    const tTags = [TagEntity(id: '1', name: 'Luxury', color: '#1B385E')];

    final container = ProviderContainer(
      overrides: [
        getTagsUseCaseProvider.overrideWithValue(
          GetTags(DummyTagRepository(tTags)),
        ),
      ],
    );
    addTearDown(container.dispose);

    final tags = await container.read(tagListProvider.future);

    expect(tags, tTags);
  });
}
