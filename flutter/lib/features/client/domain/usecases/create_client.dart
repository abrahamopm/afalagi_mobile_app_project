import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class CreateClient extends UseCase<ClientEntity, Map<String, dynamic>> {
  final ClientRepository repository;

  CreateClient(this.repository);

  @override
  Future<ClientEntity> call(Map<String, dynamic> body) {
    return repository.create(body);
  }
}
