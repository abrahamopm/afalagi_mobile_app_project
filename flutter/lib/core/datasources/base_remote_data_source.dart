import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../extensions/dio_exception_x.dart';

abstract class BaseRemoteDataSource<T> {
  final Dio dio;
  final String endpoint;
  final T Function(Map<String, dynamic> json) fromJson;

  BaseRemoteDataSource({
    required this.dio,
    required this.endpoint,
    required this.fromJson,
  });

  Future<List<T>> getAll() async {
    try {
      final response = await dio.get(endpoint);
      final data = response.data;
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((j) => fromJson(j as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(message: data['error'] ?? 'Failed to load list');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<T> getById(String id) async {
    try {
      final response = await dio.get('$endpoint/$id');
      final data = response.data;
      if (data['success'] == true) {
        return fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException(message: data['error'] ?? 'Failed to load details');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<T> create(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(endpoint, data: body);
      final data = response.data;
      if (data['success'] == true) {
        return fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException(message: data['error'] ?? 'Failed to create');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<T> update(String id, Map<String, dynamic> body) async {
    try {
      final response = await dio.put('$endpoint/$id', data: body);
      final data = response.data;
      if (data['success'] == true) {
        return fromJson(data['data'] as Map<String, dynamic>);
      }
      throw ServerException(message: data['error'] ?? 'Failed to update');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await dio.delete('$endpoint/$id');
      final data = response.data;
      if (data['success'] == true) {
        return;
      }
      throw ServerException(message: data['error'] ?? 'Failed to delete');
    } on DioException catch (e) {
      throw e.toServerException();
    }
  }
}
