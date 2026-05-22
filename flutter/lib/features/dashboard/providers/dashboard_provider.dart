import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/entities/dashboard_stats.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/usecases/get_dashboard_stats.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepositoryImpl(dio);
});

final getStatsUseCaseProvider = Provider<GetDashboardStats>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardStats(repository);
});

class DashboardNotifier extends AsyncNotifier<DashboardStats> {
  @override
  Future<DashboardStats> build() async {
    final getStats = ref.watch(getStatsUseCaseProvider);
    return getStats(NoParams());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final getStats = ref.read(getStatsUseCaseProvider);
      return getStats(NoParams());
    });
  }
}

final dashboardStatsProvider = AsyncNotifierProvider<DashboardNotifier, DashboardStats>(() {
  return DashboardNotifier();
});
