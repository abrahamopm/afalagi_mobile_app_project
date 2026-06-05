import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/features/admin/data/models/admin_stats_model.dart';
import 'package:afalagi/features/admin/data/models/admin_user_model.dart';
import 'package:afalagi/features/admin/domain/entities/admin_property_item.dart';
import 'package:afalagi/features/admin/domain/entities/admin_stats.dart';
import 'package:afalagi/features/admin/domain/entities/admin_user_summary.dart';
import 'package:afalagi/features/admin/domain/repositories/admin_repository.dart';
import 'package:afalagi/features/admin/domain/usecases/get_admin_stats.dart';
import 'package:afalagi/features/admin/domain/usecases/get_admin_users.dart';
import 'package:afalagi/features/admin/providers/admin_provider.dart';

class DummyAdminRepository implements AdminRepository {
  final AdminStats stats;
  final List<AdminUserSummary> users;

  DummyAdminRepository({required this.stats, required this.users});

  @override
  Future<AdminStats> getStats() async => stats;

  @override
  Future<List<AdminUserSummary>> getUsers() async => users;

  @override
  Future<AdminUserSummary> updateUser(
    String id, {
    bool? isActive,
    bool? isVerified,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<AdminPropertyItem>> getProperties() async =>
      throw UnimplementedError();

  @override
  Future<AdminPropertyItem> updateProperty(String id, {bool? isAvailable}) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteProperty(String id) async => throw UnimplementedError();
}

void main() {
  final tStats = AdminStatsModel(
    userCount: 10,
    propertyCount: 25,
    viewingCount: 50,
    pendingUsers: 2,
    hiddenProperties: 1,
    recentActivity: const [],
  );

  final tUsers = [
    const AdminUserModel(
      id: '1',
      name: 'Agent One',
      email: 'agent1@example.com',
      role: 'user',
    ),
  ];

  test('adminStatsProvider returns stats from overridden usecase', () async {
    final testGetAdminStats = GetAdminStats(
      DummyAdminRepository(stats: tStats, users: tUsers),
    );

    final container = ProviderContainer(
      overrides: [
        getAdminStatsUseCaseProvider.overrideWithValue(testGetAdminStats),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(adminStatsProvider.future);

    expect(result, equals(tStats));
  });

  test('adminUsersProvider returns users from overridden usecase', () async {
    final testGetAdminUsers = GetAdminUsers(
      DummyAdminRepository(stats: tStats, users: tUsers),
    );

    final container = ProviderContainer(
      overrides: [
        getAdminUsersUseCaseProvider.overrideWithValue(testGetAdminUsers),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(adminUsersProvider.future);

    expect(result, equals(tUsers));
  });
}
