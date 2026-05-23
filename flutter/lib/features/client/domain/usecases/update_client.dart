import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class UpdateClientParams {
  final String id;
  final Map<String, dynamic> body;

  const UpdateClientParams({required this.id, required this.body});
}

class UpdateClient extends UseCase<ClientEntity, UpdateClientParams> {
  final ClientRepository repository;

  UpdateClient(this.repository);

  @override
  Future<ClientEntity> call(UpdateClientParams params) {
    return repository.update(params.id, params.body);
  }
}
