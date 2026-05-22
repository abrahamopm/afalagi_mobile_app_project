import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';

class DashboardStats {
  final int propertyCount;
  final int clientCount;
  final int viewingCount;
  final int todayViewingCount;
  final List<DashboardActivity> recentActivity;

  DashboardStats({
    required this.propertyCount,
    required this.clientCount,
    required this.viewingCount,
    required this.todayViewingCount,
    required this.recentActivity,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final recent = (json['recentActivity'] as List? ?? [])
        .map((a) => DashboardActivity.fromJson(a))
        .toList();

    return DashboardStats(
      propertyCount: json['propertyCount'] ?? 0,
      clientCount: json['clientCount'] ?? 0,
      viewingCount: json['viewingCount'] ?? 0,
      todayViewingCount: json['todayViewingCount'] ?? 0,
      recentActivity: recent,
    );
  }
}

class DashboardActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;

  DashboardActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  });

  factory DashboardActivity.fromJson(Map<String, dynamic> json) {
    return DashboardActivity(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
    );
  }
}

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<DashboardStats> getStats() async {
    try {
      final response = await _dio.get(AppConstants.dashboardStats);
      final data = response.data;
      if (data['success'] == true) {
        return DashboardStats.fromJson(data['data']);
      } else {
        throw ServerException(message: data['error'] ?? 'Failed to load stats');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? 'Network error occurred';
      throw ServerException(message: message, statusCode: e.response?.statusCode);
    }
  }
}
