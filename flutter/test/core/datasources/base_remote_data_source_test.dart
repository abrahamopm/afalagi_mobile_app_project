import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/Core/datasources/base_remote_data_source.dart';
import 'package:afalagi/Core/errors/exceptions.dart';
import 'package:afalagi/features/property/data/models/property_model.dart';

class MockDio extends Mock implements Dio {}

class TestRemoteDataSource extends BaseRemoteDataSource<PropertyModel> {
  TestRemoteDataSource({required super.dio})
      : super(
          endpoint: '/properties',
          fromJson: PropertyModel.fromJson,
        );
}

void main() {
  late MockDio mockDio;
  late TestRemoteDataSource dataSource;

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
    mockDio = MockDio();
    dataSource = TestRemoteDataSource(dio: mockDio);
  });

  group('BaseRemoteDataSource Tests', () {
    test('getAll should return a list of models when response is successful', () async {
      // arrange
      final responsePayload = {
        'success': true,
        'data': [
          {
            'id': '1',
            'title': 'Test Property',
            'description': 'Test Description',
            'location': 'Test Location',
            'imageUrl': 'test.png',
            'price': 1000.0,
            'beds': 1,
            'baths': 1,
            'sqft': 100,
            'isAvailable': true,
            'tags': [],
          }
        ]
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.getAll();

      // assert
      expect(result, equals(tPropertyModelList));
      verify(() => mockDio.get('/properties')).called(1);
    });

    test('getAll should throw ServerException when response success is false', () async {
      // arrange
      final responsePayload = {
        'success': false,
        'error': 'Server Error',
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act & assert
      expect(() => dataSource.getAll(), throwsA(isA<ServerException>()));
    });

    test('getById should return a model when successful', () async {
      // arrange
      final responsePayload = {
        'success': true,
        'data': {
          'id': '1',
          'title': 'Test Property',
          'description': 'Test Description',
          'location': 'Test Location',
          'imageUrl': 'test.png',
          'price': 1000.0,
          'beds': 1,
          'baths': 1,
          'sqft': 100,
          'isAvailable': true,
          'tags': [],
        }
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties/1'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.getById('1');

      // assert
      expect(result, equals(tPropertyModel));
      verify(() => mockDio.get('/properties/1')).called(1);
    });

    test('create should return a model when successful', () async {
      // arrange
      final responsePayload = {
        'success': true,
        'data': {
          'id': '1',
          'title': 'Test Property',
          'description': 'Test Description',
          'location': 'Test Location',
          'imageUrl': 'test.png',
          'price': 1000.0,
          'beds': 1,
          'baths': 1,
          'sqft': 100,
          'isAvailable': true,
          'tags': [],
        }
      };

      final body = {'title': 'Test Property'};

      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.create(body);

      // assert
      expect(result, equals(tPropertyModel));
      verify(() => mockDio.post('/properties', data: body)).called(1);
    });

    test('update should return a model when successful', () async {
      // arrange
      final responsePayload = {
        'success': true,
        'data': {
          'id': '1',
          'title': 'Test Property',
          'description': 'Test Description',
          'location': 'Test Location',
          'imageUrl': 'test.png',
          'price': 1000.0,
          'beds': 1,
          'baths': 1,
          'sqft': 100,
          'isAvailable': true,
          'tags': [],
        }
      };

      final body = {'title': 'Test Property'};

      when(() => mockDio.put(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties/1'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.update('1', body);

      // assert
      expect(result, equals(tPropertyModel));
      verify(() => mockDio.put('/properties/1', data: body)).called(1);
    });

    test('delete should complete successfully', () async {
      // arrange
      final responsePayload = {
        'success': true,
      };

      when(() => mockDio.delete(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/properties/1'),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      // act & assert
      await expectLater(dataSource.delete('1'), completes);
      verify(() => mockDio.delete('/properties/1')).called(1);
    });
  });
}
