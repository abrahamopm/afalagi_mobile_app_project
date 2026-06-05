import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/core/network/network_info.dart';
import 'package:afalagi/features/tags/data/datasources/tag_local_ds.dart';
import 'package:afalagi/features/tags/data/datasources/tag_remote_ds.dart';
import 'package:afalagi/features/tags/data/models/tag_model.dart';
import 'package:afalagi/features/tags/data/repositories/tag_repository_impl.dart';

class MockTagRemoteDS extends Mock implements TagRemoteDS {}
class MockTagLocalDS extends Mock implements TagLocalDS {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(const TagModel(id: '', name: '', color: '#1B385E'));
    registerFallbackValue(<TagModel>[]);
  });

  late MockTagRemoteDS mockRemote;
  late MockTagLocalDS mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late TagRepositoryImpl repository;

  const tTagModel = TagModel(id: '1', name: 'Luxury', color: '#1B385E', propertyCount: 1);
  final tTagModelList = [tTagModel];

  setUp(() {
    mockRemote = MockTagRemoteDS();
    mockLocal = MockTagLocalDS();
    mockNetworkInfo = MockNetworkInfo();
    when(() => mockLocal.getCached()).thenAnswer((_) async => <TagModel>[]);
    when(() => mockLocal.getCachedById(any())).thenAnswer((_) async => null);
    repository = TagRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('TagRepositoryImpl', () {
    group('getAll', () {
      test('returns remote data and caches when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenAnswer((_) async => tTagModelList);
        when(() => mockLocal.cacheAll(any())).thenAnswer((_) async => {});

        final result = await repository.getAll();

        expect(result, tTagModelList);
        verify(() => mockLocal.cacheAll(tTagModelList)).called(1);
      });

      test('returns cached data when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCached()).thenAnswer((_) async => tTagModelList);

        final result = await repository.getAll();

        expect(result, tTagModelList);
        verifyNever(() => mockRemote.getAll());
      });
    });

    group('getById', () {
      test('returns remote item and caches when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getById('1')).thenAnswer((_) async => tTagModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.getById('1');

        expect(result, tTagModel);
        verify(() => mockLocal.cacheOne(tTagModel)).called(1);
      });
    });

    group('create', () {
      test('creates on remote and caches when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.create(any())).thenAnswer((_) async => tTagModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.create({'name': 'Luxury', 'color': '#1B385E'});

        expect(result, tTagModel);
        verify(() => mockLocal.cacheOne(tTagModel)).called(1);
      });

      test('throws ServerException when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.create({'name': 'Luxury'}), throwsA(isA<ServerException>()));
      });
    });

    group('update', () {
      test('updates on remote and caches when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.update(any(), any())).thenAnswer((_) async => tTagModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.update('1', {'name': 'Premium'});

        expect(result, tTagModel);
        verify(() => mockLocal.cacheOne(tTagModel)).called(1);
      });
    });

    group('delete', () {
      test('deletes on remote and local when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.delete('1')).thenAnswer((_) async => {});
        when(() => mockLocal.removeOne('1')).thenAnswer((_) async => {});

        await repository.delete('1');

        verify(() => mockRemote.delete('1')).called(1);
        verify(() => mockLocal.removeOne('1')).called(1);
      });
    });
  });
}
