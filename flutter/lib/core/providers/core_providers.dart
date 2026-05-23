import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_helper.dart';
import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

import 'package:flutter/foundation.dart';
import '../constants/constants.dart';
import '../util/safe_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const SafeSecureStorage(
    aOptions: AndroidOptions(),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final secureStorage = ref.watch(secureStorageProvider);
  
  dio.options.baseUrl = AppConstants.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.responseType = ResponseType.json;
  
  dio.interceptors.add(AuthInterceptor(secureStorage));
  
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }
  
  return dio;
});

final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
});

final isConnectedStateProvider = Provider<bool>((ref) {
  final connectivityState = ref.watch(connectivityStreamProvider);
  return connectivityState.when(
    data: (results) => !results.contains(ConnectivityResult.none),
    error: (_, _) => true,
    loading: () => true,
  );
});
