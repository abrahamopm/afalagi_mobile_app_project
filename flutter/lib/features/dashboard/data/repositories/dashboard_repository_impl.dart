import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio _dio;

  DashboardRepositoryImpl(this._dio);

  @override
  Future<DashboardStatsModel> getStats() async {
    try {
      final response = await _dio.get(AppConstants.dashboardStats);
      final data = response.data;
      if (data['success'] == true) {
        return DashboardStatsModel.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load stats');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
