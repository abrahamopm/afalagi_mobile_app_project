import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:afalagi/Core/database/database_helper.dart';
import 'package:afalagi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/Core/errors/exceptions.dart';
import 'package:afalagi/core/constants/Constants.dart';

// Import the generated mocks
import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([Dio, FlutterSecureStorage, DatabaseHelper])
void main() {
  late MockDio mockDio;
  late MockFlutterSecureStorage mockSecureStorage;
  late MockDatabaseHelper mockDatabaseHelper;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockDio = MockDio();
    mockSecureStorage = MockFlutterSecureStorage();
    mockDatabaseHelper = MockDatabaseHelper();
    authRepository = AuthRepositoryImpl(mockDio, mockSecureStorage, mockDatabaseHelper);
  });

  group('AuthRepositoryImpl login tests with Mockito', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUserModel = UserModel(
      id: 'user_123',
      name: 'Test User',
      email: tEmail,
    );

    final tSuccessResponse = {
      'success': true,
      'token': 'mocked_jwt_token',
      'data': {
        'id': 'user_123',
        'name': 'Test User',
        'email': tEmail,
      }
    };

    test('should return UserModel and save token when login is successful', () async {
      // arrange
      final response = Response(
        data: tSuccessResponse,
        statusCode: 200,
        requestOptions: RequestOptions(path: AppConstants.authLogin),
      );
      when(mockDio.post(
        AppConstants.authLogin,
        data: {'email': tEmail, 'password': tPassword},
      )).thenAnswer((_) async => response);

      when(mockSecureStorage.write(
        key: 'jwt_token',
        value: 'mocked_jwt_token',
      )).thenAnswer((_) async => {});

      // act
      final result = await authRepository.login(tEmail, tPassword);

      // assert
      expect(result, equals(tUserModel));
      verify(mockDio.post(
        AppConstants.authLogin,
        data: {'email': tEmail, 'password': tPassword},
      )).called(1);
      verify(mockSecureStorage.write(
        key: 'jwt_token',
        value: 'mocked_jwt_token',
      )).called(1);
    });

    test('should throw ServerException when login is unsuccessful', () async {
      // arrange
      final response = Response(
        data: {'success': false, 'error': 'Invalid credentials'},
        statusCode: 400,
        requestOptions: RequestOptions(path: AppConstants.authLogin),
      );
      when(mockDio.post(
        AppConstants.authLogin,
        data: {'email': tEmail, 'password': tPassword},
      )).thenAnswer((_) async => response);

      // act & assert
      expect(
        () => authRepository.login(tEmail, tPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
