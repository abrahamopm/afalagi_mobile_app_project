import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/viewing_model.dart';

class ViewingRepository {
  final Dio _dio;

  ViewingRepository(this._dio);

  Future<List<Viewing>> getViewings() async {
    try {
      final response = await _dio.get(AppConstants.viewings);
      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> viewingsJson = data['data'] ?? [];
        return viewingsJson.map((json) => Viewing.fromJson(json)).toList();
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load viewings');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Viewing> getViewingById(String id) async {
    try {
      final response = await _dio.get('${AppConstants.viewings}/$id');
      final data = response.data;
      if (data['success'] == true) {
        return Viewing.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load viewing');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Viewing> createViewing(Viewing viewing) async {
    try {
      final response = await _dio.post(
        AppConstants.viewings,
        data: viewing.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Viewing.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to create viewing');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Viewing> updateViewing(String id, Viewing viewing) async {
    try {
      final response = await _dio.put(
        '${AppConstants.viewings}/$id',
        data: viewing.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Viewing.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to update viewing');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<void> deleteViewing(String id) async {
    try {
      final response = await _dio.delete('${AppConstants.viewings}/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete viewing');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
