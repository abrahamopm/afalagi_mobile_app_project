import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/tag_entity.dart';
import '../repositories/tag_repository.dart';

class UpdateTagParams {
  final String id;
  final Map<String, dynamic> body;

  const UpdateTagParams({required this.id, required this.body});
}

class UpdateTag extends UseCase<TagEntity, UpdateTagParams> {
  final TagRepository repository;

  UpdateTag(this.repository);

  @override
  Future<TagEntity> call(UpdateTagParams params) {
    return repository.update(params.id, params.body);
  }
}
