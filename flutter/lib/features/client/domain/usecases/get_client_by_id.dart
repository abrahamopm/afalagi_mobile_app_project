import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class GetClientById extends UseCase<ClientEntity, String> {
  final ClientRepository repository;

  GetClientById(this.repository);

  @override
  Future<ClientEntity> call(String id) => repository.getById(id);
}
