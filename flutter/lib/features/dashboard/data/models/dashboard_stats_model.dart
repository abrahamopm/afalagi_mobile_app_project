import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.propertyCount,
    required super.clientCount,
    required super.viewingCount,
    required super.todayViewingCount,
    required List<DashboardActivityModel> super.recentActivity,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final recent = (json['recentActivity'] as List? ?? [])
        .map((a) => DashboardActivityModel.fromJson(a))
        .toList();

    return DashboardStatsModel(
      propertyCount: json['propertyCount'] ?? 0,
      clientCount: json['clientCount'] ?? 0,
      viewingCount: json['viewingCount'] ?? 0,
      todayViewingCount: json['todayViewingCount'] ?? 0,
      recentActivity: recent,
    );
  }
}

class DashboardActivityModel extends DashboardActivity {
  const DashboardActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.time,
  });

  factory DashboardActivityModel.fromJson(Map<String, dynamic> json) {
    return DashboardActivityModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
