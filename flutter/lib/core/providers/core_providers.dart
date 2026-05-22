import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final secureStorage = ref.watch(secureStorageProvider);
  dio.interceptors.add(AuthInterceptor(secureStorage));
  return dio;
});

final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});
