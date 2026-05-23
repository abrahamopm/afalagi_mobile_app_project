import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final DatabaseHelper _dbHelper;

  AuthRepositoryImpl(this._dio, this._secureStorage, this._dbHelper);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.authLogin,
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      if (data['success'] == true) {
        final token = data['token'];
        await _secureStorage.write(key: 'jwt_token', value: token);
        return UserModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
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
    try {
      final response = await _dio.post(
        AppConstants.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'agencyName': agencyName,
          'agencyLicense': agencyLicense,
        },
      );

      final data = response.data;
      if (data['success'] == true) {
        final token = data['token'];
        await _secureStorage.write(key: 'jwt_token', value: token);
        return UserModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<UserModel?> getMe() async {
    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(AppConstants.authMe);
      final data = response.data;
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to retrieve profile');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
        return null;
      }
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.put(AppConstants.authMe, data: updateData);
      final data = response.data;
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await _dio.delete(AppConstants.authMe);
      final data = response.data;
      if (data['success'] == true) {
        await logout();
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to delete account');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> logout() async {
    // 1. First attempt to call backend logout endpoint, ignoring errors if backend is unreachable
    try {
      await _dio.post('${AppConstants.baseUrl}/auth/logout');
    } catch (e) {
      // Ignore network errors on logout, we still want to clean up local state
    }
    // 2. Clear token
    await _secureStorage.delete(key: 'jwt_token');
    // 3. Clear SQLite tables to ensure strict Cache-First strategy doesn't leak data
    await _dbHelper.clearAllTables();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}
