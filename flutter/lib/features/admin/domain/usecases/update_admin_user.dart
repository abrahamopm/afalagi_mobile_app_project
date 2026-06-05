import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/admin_user_summary.dart';
import '../repositories/admin_repository.dart';

class UpdateAdminUserParams {
  final String id;
  final bool? isActive;
  final bool? isVerified;

  const UpdateAdminUserParams({
    required this.id,
    this.isActive,
    this.isVerified,
  });
}

class UpdateAdminUser extends UseCase<AdminUserSummary, UpdateAdminUserParams> {
  final AdminRepository repository;

  UpdateAdminUser(this.repository);

  @override
  Future<AdminUserSummary> call(UpdateAdminUserParams params) {
    return repository.updateUser(
      params.id,
      isActive: params.isActive,
      isVerified: params.isVerified,
    );
  }
}
