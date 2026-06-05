import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/admin_property_item.dart';
import '../repositories/admin_repository.dart';

class GetAdminProperties extends UseCase<List<AdminPropertyItem>, NoParams> {
  final AdminRepository repository;

  GetAdminProperties(this.repository);

  @override
  Future<List<AdminPropertyItem>> call(NoParams params) =>
      repository.getProperties();
}
