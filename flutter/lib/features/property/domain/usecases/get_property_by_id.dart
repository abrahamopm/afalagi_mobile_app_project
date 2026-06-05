import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

class GetPropertyById extends UseCase<PropertyEntity, String> {
  final PropertyRepository repository;

  GetPropertyById(this.repository);

  @override
  Future<PropertyEntity> call(String id) {
    return repository.getById(id);
  }
}
