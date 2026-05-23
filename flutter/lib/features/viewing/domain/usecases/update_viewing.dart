import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/viewing_entity.dart';
import '../repositories/viewing_repository.dart';

class UpdateViewingParams {
  final String id;
  final Map<String, dynamic> body;

  const UpdateViewingParams({required this.id, required this.body});
}

class UpdateViewing extends UseCase<ViewingEntity, UpdateViewingParams> {
  final ViewingRepository repository;

  UpdateViewing(this.repository);

  @override
  Future<ViewingEntity> call(UpdateViewingParams params) {
    return repository.update(params.id, params.body);
  }
}
