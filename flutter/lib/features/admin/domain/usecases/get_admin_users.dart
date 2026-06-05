import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/admin_user_summary.dart';
import '../repositories/admin_repository.dart';

class GetAdminUsers extends UseCase<List<AdminUserSummary>, NoParams> {
  final AdminRepository repository;

  GetAdminUsers(this.repository);

  @override
  Future<List<AdminUserSummary>> call(NoParams params) => repository.getUsers();
}
