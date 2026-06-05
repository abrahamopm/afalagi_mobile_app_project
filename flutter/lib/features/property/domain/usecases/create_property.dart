import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

class CreateProperty extends UseCase<PropertyEntity, Map<String, dynamic>> {
  final PropertyRepository repository;

  CreateProperty(this.repository);

  @override
  Future<PropertyEntity> call(Map<String, dynamic> body) {
    return repository.create(body);
  }
}
