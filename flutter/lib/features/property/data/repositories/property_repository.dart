import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/property_model.dart';

class PropertyRepository {
  final Dio _dio;

  PropertyRepository(this._dio);

  Future<List<Property>> getProperties() async {
    try {
      final response = await _dio.get(AppConstants.properties);
      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> propertiesJson = data['data'] ?? [];
        return propertiesJson.map((json) => Property.fromJson(json)).toList();
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load properties');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Property> getPropertyById(String id) async {
    try {
      final response = await _dio.get('${AppConstants.properties}/$id');
      final data = response.data;
      if (data['success'] == true) {
        return Property.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load property');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Property> createProperty(Property property) async {
    try {
      final response = await _dio.post(
        AppConstants.properties,
        data: property.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Property.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to create property');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Property> updateProperty(String id, Property property) async {
    try {
      final response = await _dio.put(
        '${AppConstants.properties}/$id',
        data: property.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Property.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to update property');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      final response = await _dio.delete('${AppConstants.properties}/$id');
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
