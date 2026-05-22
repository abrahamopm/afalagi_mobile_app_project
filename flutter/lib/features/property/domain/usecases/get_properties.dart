import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

class GetProperties extends UseCase<List<PropertyEntity>, NoParams> {
  final PropertyRepository repository;

  GetProperties(this.repository);

  @override
  Future<List<PropertyEntity>> call(NoParams params) {
    return repository.getAll();
  }
}
