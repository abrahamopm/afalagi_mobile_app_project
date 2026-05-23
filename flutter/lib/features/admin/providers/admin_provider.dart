import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Core/providers/core_providers.dart';
import '../data/repositories/admin_repository_impl.dart';
import '../domain/entities/admin_property_item.dart';
import '../domain/entities/admin_stats.dart';
import '../domain/entities/admin_user_summary.dart';
import '../domain/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(dioProvider));
});

class AdminStatsNotifier extends AsyncNotifier<AdminStats> {
  @override
  Future<AdminStats> build() async {
    return ref.read(adminRepositoryProvider).getStats();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getStats());
  }
}

final adminStatsProvider =
    AsyncNotifierProvider<AdminStatsNotifier, AdminStats>(AdminStatsNotifier.new);

class AdminUsersNotifier extends AsyncNotifier<List<AdminUserSummary>> {
  @override
  Future<List<AdminUserSummary>> build() async {
    return ref.read(adminRepositoryProvider).getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getUsers());
  }

  Future<void> setUserActive(String id, bool isActive) async {
    final updated = await ref.read(adminRepositoryProvider).updateUser(id, isActive: isActive);
    state = state.whenData(
      (users) => users.map((u) => u.id == id ? updated : u).toList(),
    );
  }

  Future<void> setUserVerified(String id, bool isVerified) async {
    final updated = await ref.read(adminRepositoryProvider).updateUser(id, isVerified: isVerified);
    state = state.whenData(
      (users) => users.map((u) => u.id == id ? updated : u).toList(),
    );
  }
}

final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersNotifier, List<AdminUserSummary>>(AdminUsersNotifier.new);

class AdminPropertiesNotifier extends AsyncNotifier<List<AdminPropertyItem>> {
  @override
  Future<List<AdminPropertyItem>> build() async {
    return ref.read(adminRepositoryProvider).getProperties();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getProperties());
  }

  Future<void> setAvailability(String id, bool isAvailable) async {
    final updated =
        await ref.read(adminRepositoryProvider).updateProperty(id, isAvailable: isAvailable);
    state = state.whenData(
      (items) => items.map((p) => p.id == id ? updated : p).toList(),
    );
  }

  Future<void> deleteProperty(String id) async {
    await ref.read(adminRepositoryProvider).deleteProperty(id);
    state = state.whenData((items) => items.where((p) => p.id != id).toList());
  }
}

final adminPropertiesProvider = AsyncNotifierProvider<AdminPropertiesNotifier,
    List<AdminPropertyItem>>(AdminPropertiesNotifier.new);
