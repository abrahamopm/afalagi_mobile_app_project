import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/auth/domain/repositories/auth_repository.dart';
import 'package:afalagi/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase usecase;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should logout via repository', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async => {});

      await usecase(const NoParams());

      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
