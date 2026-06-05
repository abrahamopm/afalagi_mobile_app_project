import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/get_tags.dart';
import 'package:afalagi/features/tags/providers/tag_provider.dart';
import 'package:afalagi/features/tags/screens/tag_management_screen.dart';

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
  testWidgets('TagManagementScreen displays tags from provider', (
    WidgetTester tester,
  ) async {
    const tTag = TagEntity(id: '1', name: 'Luxury', color: '#1B385E');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getTagsUseCaseProvider.overrideWithValue(
            GetTags(DummyTagRepository([tTag])),
          ),
        ],
        child: const MaterialApp(home: TagManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create New Tag'), findsOneWidget);
    expect(find.text('Active Tags'), findsOneWidget);
    expect(find.text('Luxury'), findsOneWidget);
  });

  testWidgets('TagManagementScreen shows empty state when no tags', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getTagsUseCaseProvider.overrideWithValue(
            GetTags(DummyTagRepository([])),
          ),
        ],
        child: const MaterialApp(home: TagManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No tags yet. Create one above.'), findsOneWidget);
  });
}
