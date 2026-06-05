import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/core/network/network_info.dart';
import 'package:afalagi/features/client/data/datasources/client_local_ds.dart';
import 'package:afalagi/features/client/data/datasources/client_remote_ds.dart';
import 'package:afalagi/features/client/data/models/client_model.dart';
import 'package:afalagi/features/client/data/repositories/client_repository_impl.dart';

class MockClientRemoteDS extends Mock implements ClientRemoteDS {}

class MockClientLocalDS extends Mock implements ClientLocalDS {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ClientModel(
      id: '',
      name: '',
      phone: '',
    ));
    registerFallbackValue(<ClientModel>[]);
  });

  late MockClientRemoteDS mockRemote;
  late MockClientLocalDS mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  late ClientRepositoryImpl repository;

  const tClientModel = ClientModel(
    id: '1',
    name: 'Dawit Mengistu',
    phone: '+251 911 000 000',
    priority: 'VIP',
    interest: 5,
    area: 'Bole',
    budget: '45M – 60M ETB',
    tags: [],
  );

  final tClientModelList = [tClientModel];

  setUp(() {
    mockRemote = MockClientRemoteDS();
    mockLocal = MockClientLocalDS();
    mockNetworkInfo = MockNetworkInfo();

    when(() => mockLocal.getCached()).thenAnswer((_) async => <ClientModel>[]);
    when(() => mockLocal.getCachedById(any())).thenAnswer((_) async => null);

    repository = ClientRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ClientRepositoryImpl Tests - CachedRepository', () {
    group('getAll', () {
      test('should check if device is online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenAnswer((_) async => tClientModelList);
        when(() => mockLocal.cacheAll(any())).thenAnswer((_) async => {});

        await repository.getAll();

        verify(() => mockNetworkInfo.isConnected).called(1);
      });

      test('should return remote data and cache it when device is online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenAnswer((_) async => tClientModelList);
        when(() => mockLocal.cacheAll(any())).thenAnswer((_) async => {});

        final result = await repository.getAll();

        expect(result, equals(tClientModelList));
        verify(() => mockRemote.getAll()).called(1);
        verify(() => mockLocal.cacheAll(tClientModelList)).called(1);
      });

      test('should return cached data when device is online but remote throws ServerException', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getAll()).thenThrow(const ServerException(message: 'Server Error'));
        when(() => mockLocal.getCached()).thenAnswer((_) async => tClientModelList);

        final result = await repository.getAll();

        expect(result, equals(tClientModelList));
        verify(() => mockRemote.getAll()).called(1);
        verify(() => mockLocal.getCached()).called(1);
        verifyNever(() => mockLocal.cacheAll(any()));
      });

      test('should return cached data when device is offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCached()).thenAnswer((_) async => tClientModelList);

        final result = await repository.getAll();

        expect(result, equals(tClientModelList));
        verifyZeroInteractions(mockRemote);
        verify(() => mockLocal.getCached()).called(1);
      });

      test('should throw ServerException when offline and no cached data', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCached()).thenAnswer((_) async => <ClientModel>[]);

        expect(() => repository.getAll(), throwsA(isA<ServerException>()));
      });
    });

    group('getById', () {
      test('should return remote item and cache it when device is online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.getById(any())).thenAnswer((_) async => tClientModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.getById('1');

        expect(result, equals(tClientModel));
        verify(() => mockRemote.getById('1')).called(1);
        verify(() => mockLocal.cacheOne(tClientModel)).called(1);
      });

      test('should return cached item when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocal.getCachedById(any())).thenAnswer((_) async => tClientModel);

        final result = await repository.getById('1');

        expect(result, equals(tClientModel));
        verifyZeroInteractions(mockRemote);
        verify(() => mockLocal.getCachedById('1')).called(1);
      });
    });

    group('create', () {
      test('should create item on remote and cache it when online', () async {
        final body = {'name': 'Dawit Mengistu'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.create(any())).thenAnswer((_) async => tClientModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.create(body);

        expect(result, equals(tClientModel));
        verify(() => mockRemote.create(body)).called(1);
        verify(() => mockLocal.cacheOne(tClientModel)).called(1);
      });

      test('should throw ServerException when offline', () async {
        final body = {'name': 'Dawit Mengistu'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.create(body), throwsA(isA<ServerException>()));
      });
    });

    group('update', () {
      test('should update item on remote and cache it when online', () async {
        final body = {'name': 'Updated Name'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.update(any(), any())).thenAnswer((_) async => tClientModel);
        when(() => mockLocal.cacheOne(any())).thenAnswer((_) async => {});

        final result = await repository.update('1', body);

        expect(result, equals(tClientModel));
        verify(() => mockRemote.update('1', body)).called(1);
        verify(() => mockLocal.cacheOne(tClientModel)).called(1);
      });

      test('should throw ServerException when offline', () async {
        final body = {'name': 'Updated Name'};
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.update('1', body), throwsA(isA<ServerException>()));
      });
    });

    group('delete', () {
      test('should delete item on remote and local when online', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemote.delete(any())).thenAnswer((_) async => {});
        when(() => mockLocal.removeOne(any())).thenAnswer((_) async => {});

        await repository.delete('1');

        verify(() => mockRemote.delete('1')).called(1);
        verify(() => mockLocal.removeOne('1')).called(1);
      });

      test('should throw ServerException when offline', () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.delete('1'), throwsA(isA<ServerException>()));
      });
    });
  });
}
