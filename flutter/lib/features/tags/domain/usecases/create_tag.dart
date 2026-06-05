import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/tag_entity.dart';
import '../repositories/tag_repository.dart';

class CreateTag extends UseCase<TagEntity, Map<String, dynamic>> {
  final TagRepository repository;

  CreateTag(this.repository);

  @override
  Future<TagEntity> call(Map<String, dynamic> body) {
    return repository.create(body);
  }
}
