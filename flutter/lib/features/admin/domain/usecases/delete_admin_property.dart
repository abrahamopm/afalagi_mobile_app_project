import 'package:afalagi/core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteAdminProperty extends UseCase<void, String> {
  final AdminRepository repository;

  DeleteAdminProperty(this.repository);

  @override
  Future<void> call(String id) => repository.deleteProperty(id);
}
