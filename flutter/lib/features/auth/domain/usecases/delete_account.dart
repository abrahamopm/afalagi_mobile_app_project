import 'package:afalagi/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class DeleteAccount extends UseCase<void, NoParams> {
  final AuthRepository repository;

  DeleteAccount(this.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.deleteAccount();
  }
}
