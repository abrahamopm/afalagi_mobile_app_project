import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/property/providers/property_provider.dart';
import 'package:afalagi/features/property/domain/entities/property_entity.dart';
import 'package:afalagi/features/property/domain/repositories/property_repository.dart';
import 'package:afalagi/features/property/domain/usecases/get_properties.dart';

class DummyRepository implements PropertyRepository {
  final List<PropertyEntity> list;
  DummyRepository(this.list);

  @override
  Future<List<PropertyEntity>> getAll() async => list;

  @override
  Future<PropertyEntity> getById(String id) async => throw UnimplementedError();

  @override
  Future<PropertyEntity> create(Map<String, dynamic> body) async => throw UnimplementedError();

  @override
  Future<PropertyEntity> update(String id, Map<String, dynamic> body) async => throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

void main() {
  test('propertyListProvider returns list from overridden usecase', () async {
    final tEntity = const PropertyEntity(
      id: '1',
      title: 'Test',
      description: 'Desc',
      location: 'Loc',
      imageUrl: 'img',
      price: 1000.0,
      beds: 1,
      baths: 1,
      sqft: 100,
    );

    final tList = [tEntity];

    final testGetProperties = GetProperties(DummyRepository(tList));

    final container = ProviderContainer(
      overrides: [
        getPropertiesUseCaseProvider.overrideWithValue(testGetProperties),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(propertyListProvider.future);

    expect(result, equals(tList));
  });
}
