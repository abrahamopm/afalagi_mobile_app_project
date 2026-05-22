import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/viewing_entity.dart';
import '../repositories/viewing_repository.dart';

class GetViewings extends UseCase<List<ViewingEntity>, NoParams> {
  final ViewingRepository repository;

  GetViewings(this.repository);

  @override
  Future<List<ViewingEntity>> call(NoParams params) {
    return repository.getAll();
  }
}
