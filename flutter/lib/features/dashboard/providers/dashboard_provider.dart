import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio);
});

class DashboardNotifier extends AsyncNotifier<DashboardStats> {
  late final DashboardRepository _repository;

  @override
  Future<DashboardStats> build() async {
    _repository = ref.watch(dashboardRepositoryProvider);
    return _repository.getStats();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getStats();
    });
  }
}

final dashboardStatsProvider = AsyncNotifierProvider<DashboardNotifier, DashboardStats>(() {
  return DashboardNotifier();
});
