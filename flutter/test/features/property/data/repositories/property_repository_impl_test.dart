import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/core/network/network_info.dart';
import 'package:afalagi/features/property/data/datasources/property_local_ds.dart';
import 'package:afalagi/features/property/data/datasources/property_remote_ds.dart';
import 'package:afalagi/features/property/data/models/property_model.dart';
import 'package:afalagi/features/property/data/repositories/property_repository_impl.dart';

class MockPropertyRemoteDS extends Mock implements PropertyRemoteDS {}
class MockPropertyLocalDS extends Mock implements PropertyLocalDS {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(const PropertyModel(
      id: '',
      title: '',
      description: '',
      location: '',
      imageUrl: '',
      price: 0,
      beds: 0,
      baths: 0,
      sqft: 0,
    ));
    registerFallbackValue(<PropertyModel>[]);
  });

  late MockPropertyRemoteDS mockRemote;
  late MockPropertyLocalDS mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late PropertyRepositoryImpl repository;

  const tPropertyModel = PropertyModel(
    id: '1',
    title: 'Test Property',
    description: 'Test Description',
    location: 'Test Location',
    imageUrl: 'test.png',
    price: 1000.0,
    beds: 1,
    baths: 1,
    sqft: 100,
    isAvailable: true,
    tags: [],
  );

  final tPropertyModelList = [tPropertyModel];

  setUp(() {
    mockRemote = MockPropertyRemoteDS();
    mockLocal = MockPropertyLocalDS();
    mockNetworkInfo = MockNetworkInfo();
    repository = PropertyRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('PropertyRepositoryImpl Tests - CachedRepository', () {
    group('getAll', () {
      test('should check if device is online', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenAnswer((_) async => tPropertyModelList);
        when(() => mockLocal.cacheAll(any())).thenAnswer((_) async => {});

        // act
        await repository.getAll();

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
      });

      test('should return remote data and cache it when device is online', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenAnswer((_) async => tPropertyModelList);
        when(() => mockLocal.cacheAll(any())).thenAnswer((_) async => {});

        // act
        final result = await repository.getAll();

        // assert
        expect(result, equals(tPropertyModelList));
        verify(() => mockRemote.getAll()).called(1);
        verify(() => mockLocal.cacheAll(tPropertyModelList)).called(1);
      });

      test('should return cached data when device is online but remote call throws ServerException', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenThrow(const ServerException(message: 'Server Error'));
        when(() => mockLocal.getCached()).thenAnswer((_) async => tPropertyModelList);

        // act
        final result = await repository.getAll();

        // assert
        expect(result, equals(tPropertyModelList));
        verify(() => mockRemote.getAll()).called(1);
        verify(() => mockLocal.getCached()).called(1);
        verifyNever(() => mockLocal.cacheAll(any()));
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCached()).thenAnswer((_) async => tPropertyModelList);

        // act
        final result = await repository.getAll();

        // assert
        expect(result, equals(tPropertyModelList));
        verifyZeroInteractions(mockRemote);
        verify(() => mockLocal.getCached()).called(1);
      });

      test('should throw ServerException when device is offline and no cached data exists', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCached()).thenAnswer((_) async => <PropertyModel>[]);

        // act & assert
        expect(() => repository.getAll(), throwsA(isA<ServerException>()));
      });
    });

    group('getById', () {
      test('should return remote item and cache it when device is online', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getById(any())).thenAnswer((_) async => tPropertyModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        // act
        final result = await repository.getById('1');

        // assert
        expect(result, equals(tPropertyModel));
        verify(() => mockRemote.getById('1')).called(1);
        verify(() => mockLocal.cacheOne(tPropertyModel)).called(1);
      });

      test('should return cached item when offline', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCachedById(any())).thenAnswer((_) async => tPropertyModel);

        // act
        final result = await repository.getById('1');

        // assert
        expect(result, equals(tPropertyModel));
        verifyZeroInteractions(mockRemote);
        verify(() => mockLocal.getCachedById('1')).called(1);
      });
    });

    group('create', () {
      test('should create item on remote and cache it when online', () async {
        // arrange
        final body = {'title': 'Test Property'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.create(any())).thenAnswer((_) async => tPropertyModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        // act
        final result = await repository.create(body);

        // assert
        expect(result, equals(tPropertyModel));
        verify(() => mockRemote.create(body)).called(1);
        verify(() => mockLocal.cacheOne(tPropertyModel)).called(1);
      });

      test('should throw ServerException when offline', () async {
        // arrange
        final body = {'title': 'Test Property'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act & assert
        expect(() => repository.create(body), throwsA(isA<ServerException>()));
      });
    });

    group('update', () {
      test('should update item on remote and cache it when online', () async {
        // arrange
        final body = {'title': 'Test Property'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.update(any(), any())).thenAnswer((_) async => tPropertyModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        // act
        final result = await repository.update('1', body);

        // assert
        expect(result, equals(tPropertyModel));
        verify(() => mockRemote.update('1', body)).called(1);
        verify(() => mockLocal.cacheOne(tPropertyModel)).called(1);
      });

      test('should throw ServerException when offline', () async {
        // arrange
        final body = {'title': 'Test Property'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act & assert
        expect(() => repository.update('1', body), throwsA(isA<ServerException>()));
      });
    });

    group('delete', () {
      test('should delete item on remote and local when online', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.delete(any())).thenAnswer((_) async => {});
        when(() => mockLocal.removeOne(any())).thenAnswer((_) async => {});

        // act
        await repository.delete('1');

        // assert
        verify(() => mockRemote.delete('1')).called(1);
        verify(() => mockLocal.removeOne('1')).called(1);
      });

      test('should throw ServerException when offline', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act & assert
        expect(() => repository.delete('1'), throwsA(isA<ServerException>()));
      });
    });
  });
}
