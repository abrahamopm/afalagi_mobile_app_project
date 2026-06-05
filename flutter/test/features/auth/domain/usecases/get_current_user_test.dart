import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/auth/domain/entities/user_entity.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/get_current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUser usecase;

  const tUser = UserEntity(
    id: 'user_123',
    name: 'Test User',
    email: 'test@example.com',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockRepository);
  });

  group('GetCurrentUser', () {
    test('should return current user from repository', () async {
      when(() => mockRepository.getMe()).thenAnswer((_) async => tUser);

      final result = await usecase(const NoParams());

      expect(result, equals(tUser));
      verify(() => mockRepository.getMe()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when user is not authenticated', () async {
      when(() => mockRepository.getMe()).thenAnswer((_) async => null);

      final result = await usecase(const NoParams());

      expect(result, isNull);
      verify(() => mockRepository.getMe()).called(1);
    });
  });
}
