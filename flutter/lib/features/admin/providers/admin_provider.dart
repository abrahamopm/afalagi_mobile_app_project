import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../core/providers/core_providers.dart';
import '../data/datasources/admin_remote_ds.dart';
import '../data/repositories/admin_repository_impl.dart';
import '../domain/entities/admin_property_item.dart';
import '../domain/entities/admin_stats.dart';
import '../domain/entities/admin_user_summary.dart';
import '../domain/repositories/admin_repository.dart';
import '../domain/usecases/delete_admin_property.dart';
import '../domain/usecases/get_admin_properties.dart';
import '../domain/usecases/get_admin_stats.dart';
import '../domain/usecases/get_admin_users.dart';
import '../domain/usecases/update_admin_property.dart';
import '../domain/usecases/update_admin_user.dart';

final adminRemoteDSProvider = Provider<AdminRemoteDS>((ref) {
  return AdminRemoteDS(ref.watch(dioProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteDSProvider));
});

final getAdminStatsUseCaseProvider = Provider<GetAdminStats>((ref) {
  return GetAdminStats(ref.watch(adminRepositoryProvider));
});

final getAdminUsersUseCaseProvider = Provider<GetAdminUsers>((ref) {
  return GetAdminUsers(ref.watch(adminRepositoryProvider));
});

final updateAdminUserUseCaseProvider = Provider<UpdateAdminUser>((ref) {
  return UpdateAdminUser(ref.watch(adminRepositoryProvider));
});

final getAdminPropertiesUseCaseProvider = Provider<GetAdminProperties>((ref) {
  return GetAdminProperties(ref.watch(adminRepositoryProvider));
});

final updateAdminPropertyUseCaseProvider = Provider<UpdateAdminProperty>((ref) {
  return UpdateAdminProperty(ref.watch(adminRepositoryProvider));
});

final deleteAdminPropertyUseCaseProvider = Provider<DeleteAdminProperty>((ref) {
  return DeleteAdminProperty(ref.watch(adminRepositoryProvider));
});

class AdminStatsNotifier extends AsyncNotifier<AdminStats> {
  @override
  Future<AdminStats> build() async {
    return ref.read(getAdminStatsUseCaseProvider).call(const NoParams());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getAdminStatsUseCaseProvider).call(const NoParams()),
    );
  }
}

final adminStatsProvider =
    AsyncNotifierProvider<AdminStatsNotifier, AdminStats>(
      AdminStatsNotifier.new,
    );

class AdminUsersNotifier extends AsyncNotifier<List<AdminUserSummary>> {
  @override
  Future<List<AdminUserSummary>> build() async {
    return ref.read(getAdminUsersUseCaseProvider).call(const NoParams());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getAdminUsersUseCaseProvider).call(const NoParams()),
    );
  }

  Future<void> setUserActive(String id, bool isActive) async {
    final updated = await ref.read(updateAdminUserUseCaseProvider).call(
      UpdateAdminUserParams(id: id, isActive: isActive),
    );
    state = state.whenData(
      (users) => users.map((u) => u.id == id ? updated : u).toList(),
    );
  }

  Future<void> setUserVerified(String id, bool isVerified) async {
    final updated = await ref.read(updateAdminUserUseCaseProvider).call(
      UpdateAdminUserParams(id: id, isVerified: isVerified),
    );
    state = state.whenData(
      (users) => users.map((u) => u.id == id ? updated : u).toList(),
    );
  }
}

final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersNotifier, List<AdminUserSummary>>(
      AdminUsersNotifier.new,
    );

class AdminPropertiesNotifier extends AsyncNotifier<List<AdminPropertyItem>> {
  @override
  Future<List<AdminPropertyItem>> build() async {
    return ref.read(getAdminPropertiesUseCaseProvider).call(const NoParams());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(getAdminPropertiesUseCaseProvider).call(const NoParams()),
    );
  }

  Future<void> setAvailability(String id, bool isAvailable) async {
    final updated = await ref.read(updateAdminPropertyUseCaseProvider).call(
      UpdateAdminPropertyParams(id: id, isAvailable: isAvailable),
    );
    state = state.whenData(
      (items) => items.map((p) => p.id == id ? updated : p).toList(),
    );
  }

  Future<void> deleteProperty(String id) async {
    await ref.read(deleteAdminPropertyUseCaseProvider).call(id);
    state = state.whenData((items) => items.where((p) => p.id != id).toList());
  }
}

final adminPropertiesProvider =
    AsyncNotifierProvider<AdminPropertiesNotifier, List<AdminPropertyItem>>(
      AdminPropertiesNotifier.new,
    );
