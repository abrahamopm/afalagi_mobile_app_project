import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/admin_property_item.dart';
import '../repositories/admin_repository.dart';

class UpdateAdminPropertyParams {
  final String id;
  final bool? isAvailable;

  const UpdateAdminPropertyParams({required this.id, this.isAvailable});
}

class UpdateAdminProperty
    extends UseCase<AdminPropertyItem, UpdateAdminPropertyParams> {
  final AdminRepository repository;

  UpdateAdminProperty(this.repository);

  @override
  Future<AdminPropertyItem> call(UpdateAdminPropertyParams params) {
    return repository.updateProperty(
      params.id,
      isAvailable: params.isAvailable,
    );
  }
}
