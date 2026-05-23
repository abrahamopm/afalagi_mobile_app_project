import 'package:afalagi/Core/usecases/usecase.dart';
import '../repositories/client_repository.dart';

class DeleteClient extends UseCase<void, String> {
  final ClientRepository repository;

  DeleteClient(this.repository);

  @override
  Future<void> call(String id) {
    return repository.delete(id);
  }
}
