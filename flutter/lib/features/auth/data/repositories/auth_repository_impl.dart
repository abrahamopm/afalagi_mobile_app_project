import '../../../../core/database/database_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_ds.dart';
import '../datasources/auth_remote_ds.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDS _remote;
  final AuthLocalDS _local;
  final DatabaseHelper _dbHelper;

  AuthRepositoryImpl(this._remote, this._local, this._dbHelper);

  @override
  Future<UserModel> login(String email, String password) async {
    final result = await _remote.login(email, password);
    await _local.saveToken(result.token);
    await _local.cacheUser(result.user);
    return result.user;
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String agencyName = '',
    String agencyLicense = '',
  }) async {
    final result = await _remote.signup(
      name: name,
      email: email,
      password: password,
      phone: phone,
      agencyName: agencyName,
      agencyLicense: agencyLicense,
    );
    await _local.saveToken(result.token);
    await _local.cacheUser(result.user);
    return result.user;
  }

  @override
  Future<UserModel?> getMe() async {
    if (!await _local.hasToken()) return null;
    try {
      final user = await _remote.getMe();
      await _local.cacheUser(user);
      return user;
    } on ServerException catch (e) {
      if (e.statusCode == 401) {
        await logout();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> updateData) async {
    final user = await _remote.updateProfile(updateData);
    await _local.cacheUser(user);
    return user;
  }

  @override
  Future<void> deleteAccount() async {
    await _remote.deleteAccount();
    await logout();
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    await _local.clearAll();
    await _dbHelper.clearAllTables();
  }

  @override
  Future<bool> isAuthenticated() => _local.hasToken();

  @override
  Future<void> saveRememberedEmail(String? email) =>
      _local.saveRememberedEmail(email);

  @override
  Future<String?> getRememberedEmail() => _local.getRememberedEmail();
}
