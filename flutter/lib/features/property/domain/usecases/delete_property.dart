import 'package:afalagi/Core/usecases/usecase.dart';
import '../repositories/property_repository.dart';

class DeleteProperty extends UseCase<void, String> {
  final PropertyRepository repository;

  DeleteProperty(this.repository);

  @override
  Future<void> call(String id) {
    return repository.delete(id);
  }
}
