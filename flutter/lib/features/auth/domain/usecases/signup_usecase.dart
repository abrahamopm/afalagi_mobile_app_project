import 'package:afalagi/core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupParams {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String agencyName;
  final String agencyLicense;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
    this.phone = '',
    this.agencyName = '',
    this.agencyLicense = '',
  });
}

class SignupUseCase extends UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<UserEntity> call(SignupParams params) {
    return repository.signup(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      agencyName: params.agencyName,
      agencyLicense: params.agencyLicense,
    );
  }
}
