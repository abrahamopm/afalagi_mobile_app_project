import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/tag_entity.dart';
import '../repositories/tag_repository.dart';

class GetTagById extends UseCase<TagEntity, String> {
  final TagRepository repository;

  GetTagById(this.repository);

  @override
  Future<TagEntity> call(String id) => repository.getById(id);
}
