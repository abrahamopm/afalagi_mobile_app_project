import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/extensions/dio_exception_x.dart';
import '../models/admin_property_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_user_model.dart';

class AdminRemoteDS {
  final Dio dio;

  AdminRemoteDS(this.dio);

  Future<AdminStatsModel> getStats() async {
    try {
      final response = await dio.get(AppConstants.adminStats);
      return _parseSingle(response.data, AdminStatsModel.fromJson);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<List<AdminUserModel>> getUsers() async {
    try {
      final response = await dio.get(AppConstants.adminUsers);
      return _parseList(response.data, AdminUserModel.fromJson);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<AdminUserModel> updateUser(
    String id, {
    bool? isActive,
    bool? isVerified,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (isActive != null) body['isActive'] = isActive;
      if (isVerified != null) body['isVerified'] = isVerified;
      final response = await dio.put(
        '${AppConstants.adminUsers}/$id',
        data: body,
      );
      return _parseSingle(response.data, AdminUserModel.fromJson);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<List<AdminPropertyModel>> getProperties() async {
    try {
      final response = await dio.get(AppConstants.adminProperties);
      return _parseList(response.data, AdminPropertyModel.fromJson);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<AdminPropertyModel> updateProperty(
    String id, {
    bool? isAvailable,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (isAvailable != null) body['isAvailable'] = isAvailable;
      final response = await dio.put(
        '${AppConstants.adminProperties}/$id',
        data: body,
      );
      return _parseSingle(response.data, AdminPropertyModel.fromJson);
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      final response = await dio.delete('${AppConstants.adminProperties}/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete property');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  T _parseSingle<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data['success'] == true) {
      return fromJson(data['data'] as Map<String, dynamic>);
    }
    throw ServerException(message: data['error'] ?? 'Request failed');
  }

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data['success'] == true) {
      return (data['data'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(message: data['error'] ?? 'Request failed');
  }
}
