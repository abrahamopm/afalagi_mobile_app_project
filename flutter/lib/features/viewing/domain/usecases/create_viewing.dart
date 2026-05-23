import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/viewing_entity.dart';
import '../repositories/viewing_repository.dart';

class CreateViewing extends UseCase<ViewingEntity, Map<String, dynamic>> {
  final ViewingRepository repository;

  CreateViewing(this.repository);

  @override
  Future<ViewingEntity> call(Map<String, dynamic> body) {
    return repository.create(body);
  }
}
