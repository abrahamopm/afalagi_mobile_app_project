import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/admin/data/datasources/admin_remote_ds.dart';
import 'package:afalagi/features/admin/data/models/admin_stats_model.dart';
import 'package:afalagi/features/admin/data/models/admin_user_model.dart';
import 'package:afalagi/features/admin/data/repositories/admin_repository_impl.dart';

class MockAdminRemoteDS extends Mock implements AdminRemoteDS {}

void main() {
  late MockAdminRemoteDS mockRemote;
  late AdminRepositoryImpl repository;

  final tStats = AdminStatsModel(
    userCount: 10,
    propertyCount: 25,
    viewingCount: 50,
    pendingUsers: 2,
    hiddenProperties: 1,
    recentActivity: const [
      AdminActivityModel(
        id: '1',
        type: 'user',
        title: 'New User',
        description: 'Agent joined',
        time: '2h ago',
      ),
    ],
  );

  final tUsers = [
    const AdminUserModel(
      id: '1',
      name: 'Agent One',
      email: 'agent1@example.com',
      role: 'user',
    ),
  ];

  setUp(() {
    mockRemote = MockAdminRemoteDS();
    repository = AdminRepositoryImpl(mockRemote);
  });

  group('AdminRepositoryImpl', () {
    test('getStats should delegate to remote data source', () async {
      when(() => mockRemote.getStats()).thenAnswer((_) async => tStats);

      final result = await repository.getStats();

      expect(result, equals(tStats));
      verify(() => mockRemote.getStats()).called(1);
    });

    test('getUsers should delegate to remote data source', () async {
      when(() => mockRemote.getUsers()).thenAnswer((_) async => tUsers);

      final result = await repository.getUsers();

      expect(result, equals(tUsers));
      verify(() => mockRemote.getUsers()).called(1);
    });
  });
}
