import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/get_properties.dart';
import 'package:afalagi/features/property/providers/property_provider.dart';
import 'package:afalagi/features/property/screens/property_list_screen.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/get_tags.dart';
import 'package:afalagi/features/tags/providers/tag_provider.dart';

class DummyPropertyRepository implements PropertyRepository {
  final List<PropertyEntity> list;

  DummyPropertyRepository(this.list);

  @override
  Future<List<PropertyEntity>> getAll() async => list;

  @override
  Future<PropertyEntity> getById(String id) async => throw UnimplementedError();

  @override
  Future<PropertyEntity> create(Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<PropertyEntity> update(String id, Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

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
  testWidgets('PropertyListScreen displays properties from provider', (
    WidgetTester tester,
  ) async {
    const tProperty = PropertyEntity(
      id: '1',
      title: 'Luxury Villa',
      description: 'A beautiful villa',
      location: 'Bole',
      imageUrl: 'assets/images/villa.png',
      price: 1200000.0,
      beds: 4,
      baths: 3,
      sqft: 3500,
      tags: ['Pool'],
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PropertyListScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getPropertiesUseCaseProvider.overrideWithValue(
            GetProperties(DummyPropertyRepository([tProperty])),
          ),
          getTagsUseCaseProvider.overrideWithValue(
            GetTags(DummyTagRepository(const [])),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Luxury Villa'), findsOneWidget);
    expect(find.text('All Properties'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('PropertyListScreen shows empty state when no properties', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PropertyListScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getPropertiesUseCaseProvider.overrideWithValue(
            GetProperties(DummyPropertyRepository(const [])),
          ),
          getTagsUseCaseProvider.overrideWithValue(
            GetTags(DummyTagRepository(const [])),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No properties listed yet.'), findsOneWidget);
    expect(find.text('Add Your First Listing'), findsOneWidget);
  });
}
