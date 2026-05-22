import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../models/client_model.dart';

class ClientRepository {
  final Dio _dio;

  ClientRepository(this._dio);

  Future<List<Client>> getClients() async {
    try {
      final response = await _dio.get(AppConstants.clients);
      final data = response.data;
      if (data['success'] == true) {
        final List<dynamic> clientsJson = data['data'] ?? [];
        return clientsJson.map((json) => Client.fromJson(json)).toList();
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load clients');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Client> getClientById(String id) async {
    try {
      final response = await _dio.get('${AppConstants.clients}/$id');
      final data = response.data;
      if (data['success'] == true) {
        return Client.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load client');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Client> createClient(Client client) async {
    try {
      final response = await _dio.post(
        AppConstants.clients,
        data: client.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Client.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to create client');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<Client> updateClient(String id, Client client) async {
    try {
      final response = await _dio.put(
        '${AppConstants.clients}/$id',
        data: client.toJson(),
      );
      final data = response.data;
      if (data['success'] == true) {
        return Client.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to update client');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      final response = await _dio.delete('${AppConstants.clients}/$id');
      final data = response.data;
      if (data['success'] != true) {
        throw ServerException(message: data['error'] ?? 'Failed to delete client');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
