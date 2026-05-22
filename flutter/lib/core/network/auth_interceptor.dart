import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Retrieve JWT from secure storage
    final token = await _secureStorage.read(key: 'jwt_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If unauthorized response is received, clear token automatically
    if (err.response?.statusCode == 401) {
      await _secureStorage.delete(key: 'jwt_token');
    }
    super.onError(err, handler);
  }
}
