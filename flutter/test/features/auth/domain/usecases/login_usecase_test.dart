import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/auth/domain/entities/user_entity.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  late MockAuthRepository mockRepository;
  late LoginUseCase usecase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = UserEntity(
    id: 'user_123',
    name: 'Test User',
    email: tEmail,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    test('should login via repository with email and password', () async {
      when(() => mockRepository.login(any(), any())).thenAnswer((_) async => tUser);

      final result = await usecase(const LoginParams(
        email: tEmail,
        password: tPassword,
      ));

      expect(result, equals(tUser));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
