import 'package:afalagi/core/usecases/usecase.dart';
import '../repositories/tag_repository.dart';

class DeleteTag extends UseCase<void, String> {
  final TagRepository repository;

  DeleteTag(this.repository);

  @override
  Future<void> call(String id) {
    return repository.delete(id);
  }
}
