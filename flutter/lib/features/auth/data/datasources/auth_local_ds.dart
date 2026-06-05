import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthLocalDS {
  static const _tokenKey = 'jwt_token';
  static const _rememberedEmailKey = 'remembered_email';
  static const _cachedUserKey = 'cached_user';

  final FlutterSecureStorage secureStorage;

  AuthLocalDS(this.secureStorage);

  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveRememberedEmail(String? email) async {
    if (email == null || email.isEmpty) {
      await secureStorage.delete(key: _rememberedEmailKey);
    } else {
      await secureStorage.write(key: _rememberedEmailKey, value: email);
    }
  }

  Future<String?> getRememberedEmail() async {
    return secureStorage.read(key: _rememberedEmailKey);
  }

  Future<void> cacheUser(UserModel user) async {
    await secureStorage.write(
      key: _cachedUserKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getCachedUser() async {
    final raw = await secureStorage.read(key: _cachedUserKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearCachedUser() async {
    await secureStorage.delete(key: _cachedUserKey);
  }

  Future<void> clearAll() async {
    await deleteToken();
    await clearCachedUser();
  }
}
