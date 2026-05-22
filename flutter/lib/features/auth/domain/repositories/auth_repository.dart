import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String agencyName = '',
    String agencyLicense = '',
  });
  Future<UserEntity?> getMe();
  Future<UserEntity> updateProfile(Map<String, dynamic> updateData);
  Future<void> deleteAccount();
  Future<void> logout();
  Future<bool> isAuthenticated();
}
