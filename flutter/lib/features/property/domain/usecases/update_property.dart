import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

class UpdatePropertyParams {
  final String id;
  final Map<String, dynamic> body;

  const UpdatePropertyParams({required this.id, required this.body});
}

class UpdateProperty extends UseCase<PropertyEntity, UpdatePropertyParams> {
  final PropertyRepository repository;

  UpdateProperty(this.repository);

  @override
  Future<PropertyEntity> call(UpdatePropertyParams params) {
    return repository.update(params.id, params.body);
  }
}
