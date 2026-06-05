import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/client_entity.dart';
import '../repositories/client_repository.dart';

class GetClients extends UseCase<List<ClientEntity>, NoParams> {
  final ClientRepository repository;

  GetClients(this.repository);

  @override
  Future<List<ClientEntity>> call(NoParams params) {
    return repository.getAll();
  }
}
