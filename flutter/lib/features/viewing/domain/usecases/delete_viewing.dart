import 'package:afalagi/Core/usecases/usecase.dart';
import '../repositories/viewing_repository.dart';

class DeleteViewing extends UseCase<void, String> {
  final ViewingRepository repository;

  DeleteViewing(this.repository);

  @override
  Future<void> call(String id) {
    return repository.delete(id);
  }
}
