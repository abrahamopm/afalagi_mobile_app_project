import 'package:dio/dio.dart';
import '../../../../Core/constants/constants.dart';
import '../../../../Core/errors/exceptions.dart';
import '../../domain/entities/admin_property_item.dart';
import '../../domain/entities/admin_stats.dart';
import '../../domain/entities/admin_user_summary.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/admin_property_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final Dio _dio;

  AdminRepositoryImpl(this._dio);

  @override
  Future<AdminStats> getStats() async {
    try {
      final response = await _dio.get(AppConstants.adminStats);
      final data = response.data;
      if (data['success'] == true) {
        return AdminStatsModel.fromJson(data['data']);
      }
      throw ServerException(message: data['error'] ?? 'Failed to load admin stats');
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<AdminUserSummary>> getUsers() async {
    try {
      final response = await _dio.get(AppConstants.adminUsers);
      final data = response.data;
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((u) => AdminUserModel.fromJson(u as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: data['error'] ?? 'Failed to load users');
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<AdminUserSummary> updateUser(
    String id, {
    bool? isActive,
    bool? isVerified,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (isActive != null) body['isActive'] = isActive;
      if (isVerified != null) body['isVerified'] = isVerified;
      final response = await _dio.put(
        '${AppConstants.adminUsers}/$id',
        data: body,
      );
      final data = response.data;
      if (data['success'] == true) {
        return AdminUserModel.fromJson(data['data']);
      }
      throw ServerException(message: data['error'] ?? 'Failed to update user');
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<AdminPropertyItem>> getProperties() async {
    try {
      final response = await _dio.get(AppConstants.adminProperties);
      final data = response.data;
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((p) => AdminPropertyModel.fromJson(p as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: data['error'] ?? 'Failed to load properties');
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<AdminPropertyItem> updateProperty(String id, {bool? isAvailable}) async {
    try {
      final body = <String, dynamic>{};
      if (isAvailable != null) body['isAvailable'] = isAvailable;
      final response = await _dio.put(
        '${AppConstants.adminProperties}/$id',
        data: body,
      );
      final data = response.data;
      if (data['success'] == true) {
        return AdminPropertyModel.fromJson(data['data']);
      }
      throw ServerException(message: data['error'] ?? 'Failed to update property');
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      final response = await _dio.delete('${AppConstants.adminProperties}/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete property');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
