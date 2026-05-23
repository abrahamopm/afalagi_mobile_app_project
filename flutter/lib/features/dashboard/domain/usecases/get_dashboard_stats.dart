import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats extends UseCase<DashboardStats, NoParams> {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  @override
  Future<DashboardStats> call(NoParams params) {
    return repository.getStats();
  }
}
