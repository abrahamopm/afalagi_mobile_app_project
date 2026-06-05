import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/constants/constants.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDS dataSource;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUserModel = UserModel(
    id: 'user_123',
    name: 'Test User',
    email: tEmail,
  );
  const tToken = 'mocked_jwt_token';

  final tAuthSuccessResponse = {
    'success': true,
    'token': tToken,
    'data': {
      'id': 'user_123',
      'name': 'Test User',
      'email': tEmail,
    },
  };

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDS(mockDio);
  });

  group('AuthRemoteDS login', () {
    test('should return user and token when login is successful', () async {
      when(() => mockDio.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authLogin),
          data: tAuthSuccessResponse,
          statusCode: 200,
        ),
      );

      final result = await dataSource.login(tEmail, tPassword);

      expect(result.user, equals(tUserModel));
      expect(result.token, equals(tToken));
      verify(() => mockDio.post(
            AppConstants.authLogin,
            data: {'email': tEmail, 'password': tPassword},
          )).called(1);
    });

    test('should throw ServerException when login response success is false', () async {
      when(() => mockDio.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authLogin),
          data: {'success': false, 'error': 'Invalid credentials'},
          statusCode: 400,
        ),
      );

      expect(
        () => dataSource.login(tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when DioException occurs', () async {
      when(() => mockDio.post(
            AppConstants.authLogin,
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: AppConstants.authLogin),
          response: Response(
            requestOptions: RequestOptions(path: AppConstants.authLogin),
            statusCode: 500,
            data: {'error': 'Server error'},
          ),
        ),
      );

      expect(
        () => dataSource.login(tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDS signup', () {
    test('should return user and token when signup is successful', () async {
      when(() => mockDio.post(
            AppConstants.authRegister,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authRegister),
          data: tAuthSuccessResponse,
          statusCode: 201,
        ),
      );

      final result = await dataSource.signup(
        name: 'Test User',
        email: tEmail,
        password: tPassword,
      );

      expect(result.user, equals(tUserModel));
      expect(result.token, equals(tToken));
      verify(() => mockDio.post(
            AppConstants.authRegister,
            data: {
              'name': 'Test User',
              'email': tEmail,
              'password': tPassword,
              'phone': '',
              'agencyName': '',
              'agencyLicense': '',
            },
          )).called(1);
    });

    test('should throw ServerException when signup response success is false', () async {
      when(() => mockDio.post(
            AppConstants.authRegister,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authRegister),
          data: {'success': false, 'error': 'Email already exists'},
          statusCode: 400,
        ),
      );

      expect(
        () => dataSource.signup(
          name: 'Test User',
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AuthRemoteDS getMe', () {
    test('should return UserModel when getMe is successful', () async {
      when(() => mockDio.get(AppConstants.authMe)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authMe),
          data: {
            'success': true,
            'data': {
              'id': 'user_123',
              'name': 'Test User',
              'email': tEmail,
            },
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getMe();

      expect(result, equals(tUserModel));
      verify(() => mockDio.get(AppConstants.authMe)).called(1);
    });

    test('should throw ServerException when getMe response success is false', () async {
      when(() => mockDio.get(AppConstants.authMe)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.authMe),
          data: {'success': false, 'error': 'Unauthorized'},
          statusCode: 401,
        ),
      );

      expect(() => dataSource.getMe(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when DioException occurs on getMe', () async {
      when(() => mockDio.get(AppConstants.authMe)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: AppConstants.authMe),
          response: Response(
            requestOptions: RequestOptions(path: AppConstants.authMe),
            statusCode: 401,
            data: {'error': 'Unauthorized'},
          ),
        ),
      );

      expect(() => dataSource.getMe(), throwsA(isA<ServerException>()));
    });
  });
}
