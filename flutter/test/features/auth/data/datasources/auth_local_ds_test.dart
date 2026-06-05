import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/auth/data/datasources/auth_local_ds.dart';
import 'package:afalagi/features/auth/data/models/user_model.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late AuthLocalDS dataSource;

  const tToken = 'jwt_token_value';
  const tEmail = 'remembered@example.com';
  const tUserModel = UserModel(
    id: 'user_123',
    name: 'Test User',
    email: 'test@example.com',
  );

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDS(mockSecureStorage);
  });

  group('AuthLocalDS token', () {
    test('saveToken should write token to secure storage', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => {});

      await dataSource.saveToken(tToken);

      verify(() => mockSecureStorage.write(
            key: 'jwt_token',
            value: tToken,
          )).called(1);
    });

    test('getToken should read token from secure storage', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => tToken);

      final result = await dataSource.getToken();

      expect(result, equals(tToken));
      verify(() => mockSecureStorage.read(key: 'jwt_token')).called(1);
    });

    test('deleteToken should delete token from secure storage', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});

      await dataSource.deleteToken();

      verify(() => mockSecureStorage.delete(key: 'jwt_token')).called(1);
    });

    test('hasToken should return true when token exists', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => tToken);

      final result = await dataSource.hasToken();

      expect(result, isTrue);
    });

    test('hasToken should return false when token is null', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await dataSource.hasToken();

      expect(result, isFalse);
    });

    test('hasToken should return false when token is empty', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => '');

      final result = await dataSource.hasToken();

      expect(result, isFalse);
    });
  });

  group('AuthLocalDS remember email', () {
    test('saveRememberedEmail should write email when provided', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => {});

      await dataSource.saveRememberedEmail(tEmail);

      verify(() => mockSecureStorage.write(
            key: 'remembered_email',
            value: tEmail,
          )).called(1);
    });

    test('saveRememberedEmail should delete key when email is null', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});

      await dataSource.saveRememberedEmail(null);

      verify(() => mockSecureStorage.delete(key: 'remembered_email')).called(1);
      verifyNever(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ));
    });

    test('saveRememberedEmail should delete key when email is empty', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});

      await dataSource.saveRememberedEmail('');

      verify(() => mockSecureStorage.delete(key: 'remembered_email')).called(1);
    });

    test('getRememberedEmail should read email from secure storage', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => tEmail);

      final result = await dataSource.getRememberedEmail();

      expect(result, equals(tEmail));
      verify(() => mockSecureStorage.read(key: 'remembered_email')).called(1);
    });
  });

  group('AuthLocalDS cache user', () {
    test('cacheUser should write encoded user json', () async {
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => {});

      await dataSource.cacheUser(tUserModel);

      verify(() => mockSecureStorage.write(
            key: 'cached_user',
            value: jsonEncode(tUserModel.toJson()),
          )).called(1);
    });

    test('getCachedUser should return UserModel when valid json exists', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key'))).thenAnswer(
        (_) async => jsonEncode(tUserModel.toJson()),
      );

      final result = await dataSource.getCachedUser();

      expect(result, equals(tUserModel));
    });

    test('getCachedUser should return null when no cached data', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await dataSource.getCachedUser();

      expect(result, isNull);
    });

    test('getCachedUser should return null when json is invalid', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'not-valid-json');

      final result = await dataSource.getCachedUser();

      expect(result, isNull);
    });

    test('clearCachedUser should delete cached user key', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});

      await dataSource.clearCachedUser();

      verify(() => mockSecureStorage.delete(key: 'cached_user')).called(1);
    });

    test('clearAll should delete token and cached user', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});

      await dataSource.clearAll();

      verify(() => mockSecureStorage.delete(key: 'jwt_token')).called(1);
      verify(() => mockSecureStorage.delete(key: 'cached_user')).called(1);
    });
  });
}
