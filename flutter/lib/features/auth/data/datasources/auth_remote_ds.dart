import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/extensions/dio_exception_x.dart';
import '../models/user_model.dart';

class AuthRemoteDS {
  final Dio dio;

  AuthRemoteDS(this.dio);

  Future<({UserModel user, String token})> login(
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        AppConstants.authLogin,
        data: {'email': email, 'password': password},
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<({UserModel user, String token})> signup({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String agencyName = '',
    String agencyLicense = '',
  }) async {
    try {
      final response = await dio.post(
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
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await dio.get(AppConstants.authMe);
      final data = response.data;
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      }
      throw ServerException(message: data['error'] ?? 'Failed to retrieve profile');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await dio.put(AppConstants.authMe, data: updateData);
      final data = response.data;
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      }
      throw ServerException(message: data['error'] ?? 'Failed to update profile');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<void> deleteAccount() async {
    try {
      final response = await dio.delete(AppConstants.authMe);
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete account');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('${AppConstants.baseUrl}/auth/logout');
    } catch (_) {
      // Best-effort server logout
    }
  }

  ({UserModel user, String token}) _parseAuthResponse(dynamic data) {
    if (data['success'] == true) {
      return (
        user: UserModel.fromJson(data['data']),
        token: data['token'] as String,
      );
    }
    throw ServerException(message: data['error'] ?? 'Authentication failed');
  }
}
