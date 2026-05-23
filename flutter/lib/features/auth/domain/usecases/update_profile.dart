import 'package:afalagi/Core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile extends UseCase<UserEntity, Map<String, dynamic>> {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<UserEntity> call(Map<String, dynamic> updateData) {
    return repository.updateProfile(updateData);
  }
}
