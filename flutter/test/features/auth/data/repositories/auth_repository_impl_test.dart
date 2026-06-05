import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/database/database_helper.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/features/auth/data/datasources/auth_local_ds.dart';
import 'package:afalagi/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';
import 'package:afalagi/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDS extends Mock implements AuthRemoteDS {}

class MockAuthLocalDS extends Mock implements AuthLocalDS {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  setUpAll(() {
    registerFallbackValue(const UserModel(id: '', name: '', email: ''));
  });

  late MockAuthRemoteDS mockRemote;
  late MockAuthLocalDS mockLocal;
  late MockDatabaseHelper mockDbHelper;
  late AuthRepositoryImpl repository;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = 'mocked_jwt_token';
  const tUserModel = UserModel(
    id: 'user_123',
    name: 'Test User',
    email: tEmail,
  );

  setUp(() {
    mockRemote = MockAuthRemoteDS();
    mockLocal = MockAuthLocalDS();
    mockDbHelper = MockDatabaseHelper();
    repository = AuthRepositoryImpl(mockRemote, mockLocal, mockDbHelper);
  });

  group('AuthRepositoryImpl login', () {
    test('should return user and persist token and cached user', () async {
      when(() => mockRemote.login(any(), any())).thenAnswer(
        (_) async => (user: tUserModel, token: tToken),
      );
      when(() => mockLocal.saveToken(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.login(tEmail, tPassword);

      expect(result, equals(tUserModel));
      verify(() => mockRemote.login(tEmail, tPassword)).called(1);
      verify(() => mockLocal.saveToken(tToken)).called(1);
      verify(() => mockLocal.cacheUser(tUserModel)).called(1);
    });
  });

  group('AuthRepositoryImpl signup', () {
    test('should return user and persist token and cached user', () async {
      when(() => mockRemote.signup(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            phone: any(named: 'phone'),
            agencyName: any(named: 'agencyName'),
            agencyLicense: any(named: 'agencyLicense'),
          )).thenAnswer(
        (_) async => (user: tUserModel, token: tToken),
      );
      when(() => mockLocal.saveToken(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.signup(
        name: 'Test User',
        email: tEmail,
        password: tPassword,
      );

      expect(result, equals(tUserModel));
      verify(() => mockRemote.signup(
            name: 'Test User',
            email: tEmail,
            password: tPassword,
            phone: '',
            agencyName: '',
            agencyLicense: '',
          )).called(1);
      verify(() => mockLocal.saveToken(tToken)).called(1);
      verify(() => mockLocal.cacheUser(tUserModel)).called(1);
    });
  });

  group('AuthRepositoryImpl getMe', () {
    test('should return null when no token exists', () async {
      when(() => mockLocal.hasToken()).thenAnswer((_) async => false);

      final result = await repository.getMe();

      expect(result, isNull);
      verifyNever(() => mockRemote.getMe());
    });

    test('should return user and cache when token exists and remote succeeds', () async {
      when(() => mockLocal.hasToken()).thenAnswer((_) async => true);
      when(() => mockRemote.getMe()).thenAnswer((_) async => tUserModel);
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.getMe();

      expect(result, equals(tUserModel));
      verify(() => mockRemote.getMe()).called(1);
      verify(() => mockLocal.cacheUser(tUserModel)).called(1);
    });

    test('should logout and return null on 401 ServerException', () async {
      when(() => mockLocal.hasToken()).thenAnswer((_) async => true);
      when(() => mockRemote.getMe()).thenThrow(
        const ServerException(message: 'Unauthorized', statusCode: 401),
      );
      when(() => mockRemote.logout()).thenAnswer((_) async => {});
      when(() => mockLocal.clearAll()).thenAnswer((_) async => {});
      when(() => mockDbHelper.clearAllTables()).thenAnswer((_) async => {});

      final result = await repository.getMe();

      expect(result, isNull);
      verify(() => mockRemote.logout()).called(1);
      verify(() => mockLocal.clearAll()).called(1);
      verify(() => mockDbHelper.clearAllTables()).called(1);
    });

    test('should rethrow non-401 ServerException', () async {
      when(() => mockLocal.hasToken()).thenAnswer((_) async => true);
      when(() => mockRemote.getMe()).thenThrow(
        const ServerException(message: 'Server Error', statusCode: 500),
      );

      expect(() => repository.getMe(), throwsA(isA<ServerException>()));
    });
  });

  group('AuthRepositoryImpl updateProfile', () {
    test('should return updated user and cache it', () async {
      final updateData = {'name': 'Updated Name'};
      const updatedUser = UserModel(
        id: 'user_123',
        name: 'Updated Name',
        email: tEmail,
      );

      when(() => mockRemote.updateProfile(any())).thenAnswer(
        (_) async => updatedUser,
      );
      when(() => mockLocal.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.updateProfile(updateData);

      expect(result, equals(updatedUser));
      verify(() => mockRemote.updateProfile(updateData)).called(1);
      verify(() => mockLocal.cacheUser(updatedUser)).called(1);
    });
  });

  group('AuthRepositoryImpl deleteAccount', () {
    test('should delete remote account and logout locally', () async {
      when(() => mockRemote.deleteAccount()).thenAnswer((_) async => {});
      when(() => mockRemote.logout()).thenAnswer((_) async => {});
      when(() => mockLocal.clearAll()).thenAnswer((_) async => {});
      when(() => mockDbHelper.clearAllTables()).thenAnswer((_) async => {});

      await repository.deleteAccount();

      verify(() => mockRemote.deleteAccount()).called(1);
      verify(() => mockRemote.logout()).called(1);
      verify(() => mockLocal.clearAll()).called(1);
      verify(() => mockDbHelper.clearAllTables()).called(1);
    });
  });

  group('AuthRepositoryImpl logout', () {
    test('should logout remotely and clear local data and database', () async {
      when(() => mockRemote.logout()).thenAnswer((_) async => {});
      when(() => mockLocal.clearAll()).thenAnswer((_) async => {});
      when(() => mockDbHelper.clearAllTables()).thenAnswer((_) async => {});

      await repository.logout();

      verify(() => mockRemote.logout()).called(1);
      verify(() => mockLocal.clearAll()).called(1);
      verify(() => mockDbHelper.clearAllTables()).called(1);
    });
  });

  group('AuthRepositoryImpl remember email', () {
    test('saveRememberedEmail should delegate to local data source', () async {
      when(() => mockLocal.saveRememberedEmail(any())).thenAnswer((_) async => {});

      await repository.saveRememberedEmail(tEmail);

      verify(() => mockLocal.saveRememberedEmail(tEmail)).called(1);
    });

    test('getRememberedEmail should delegate to local data source', () async {
      when(() => mockLocal.getRememberedEmail()).thenAnswer((_) async => tEmail);

      final result = await repository.getRememberedEmail();

      expect(result, equals(tEmail));
      verify(() => mockLocal.getRememberedEmail()).called(1);
    });

    test('isAuthenticated should delegate to local hasToken', () async {
      when(() => mockLocal.hasToken()).thenAnswer((_) async => true);

      final result = await repository.isAuthenticated();

      expect(result, isTrue);
      verify(() => mockLocal.hasToken()).called(1);
    });
  });
}
