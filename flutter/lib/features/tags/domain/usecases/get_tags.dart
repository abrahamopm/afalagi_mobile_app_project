import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/tag_entity.dart';
import '../repositories/tag_repository.dart';

class GetTags extends UseCase<List<TagEntity>, NoParams> {
  final TagRepository repository;

  GetTags(this.repository);

  @override
  Future<List<TagEntity>> call(NoParams params) {
    return repository.getAll();
  }
}
