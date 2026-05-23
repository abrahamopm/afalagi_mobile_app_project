import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

extension DioExceptionX on DioException {
  String get userMessage {
    try {
      if (response != null && response!.data != null) {
        if (response!.data is Map) {
          return response!.data['error'] ??
              response!.data['message'] ??
              'Network error occurred';
        }
      }
    } catch (_) {}
    return message ?? 'Network error occurred';
  }

  int? get errorCode => response?.statusCode;

  ServerException toServerException() {
    return ServerException(message: userMessage, statusCode: errorCode);
  }
}
