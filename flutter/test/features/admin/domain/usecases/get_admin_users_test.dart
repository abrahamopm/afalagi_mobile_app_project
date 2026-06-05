import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/admin/data/models/admin_user_model.dart';
import 'package:afalagi/features/admin/domain/repositories/admin_repository.dart';
import 'package:afalagi/features/admin/domain/usecases/get_admin_users.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepository;
  late GetAdminUsers usecase;

  final tUsers = [
    const AdminUserModel(
      id: '1',
      name: 'Agent One',
      email: 'agent1@example.com',
      role: 'user',
    ),
  ];

  setUp(() {
    mockRepository = MockAdminRepository();
    usecase = GetAdminUsers(mockRepository);
  });

  group('GetAdminUsers', () {
    test('should get admin users from repository', () async {
      when(() => mockRepository.getUsers()).thenAnswer((_) async => tUsers);

      final result = await usecase(const NoParams());

      expect(result, equals(tUsers));
      verify(() => mockRepository.getUsers()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
