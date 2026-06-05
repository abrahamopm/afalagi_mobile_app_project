import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/admin_stats.dart';
import '../repositories/admin_repository.dart';

class GetAdminStats extends UseCase<AdminStats, NoParams> {
  final AdminRepository repository;

  GetAdminStats(this.repository);

  @override
  Future<AdminStats> call(NoParams params) => repository.getStats();
}
