import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/tag_model.dart';

class TagRepository {
  final Dio _dio;

  TagRepository(this._dio);

  Future<List<TagModel>> getTags() async {
    try {
      final response = await _dio.get(AppConstants.tags);
      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> tagsJson = data['data'] ?? [];
        return tagsJson.map((json) => TagModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load tags');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<TagModel> createTag(TagModel tag) async {
    try {
      final response = await _dio.post(
        AppConstants.tags,
        data: tag.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return TagModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to create tag');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<TagModel> updateTag(String id, TagModel tag) async {
    try {
      final response = await _dio.put(
        '${AppConstants.tags}/$id',
        data: tag.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return TagModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to update tag');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<void> deleteTag(String id) async {
    try {
      final response = await _dio.delete('${AppConstants.tags}/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete tag');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
