import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/auth/domain/entities/user_entity.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/signup_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const SignupParams(
      name: '',
      email: '',
      password: '',
    ));
  });

  late MockAuthRepository mockRepository;
  late SignupUseCase usecase;

  const tUser = UserEntity(
    id: 'user_123',
    name: 'Test User',
    email: 'test@example.com',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignupUseCase(mockRepository);
  });

  group('SignupUseCase', () {
    test('should signup via repository with all params', () async {
      when(() => mockRepository.signup(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
            phone: any(named: 'phone'),
            agencyName: any(named: 'agencyName'),
            agencyLicense: any(named: 'agencyLicense'),
          )).thenAnswer((_) async => tUser);

      final result = await usecase(const SignupParams(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        phone: '+251911',
        agencyName: 'Agency',
        agencyLicense: 'LIC-001',
      ));

      expect(result, equals(tUser));
      verify(() => mockRepository.signup(
            name: 'Test User',
            email: 'test@example.com',
            password: 'password123',
            phone: '+251911',
            agencyName: 'Agency',
            agencyLicense: 'LIC-001',
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
