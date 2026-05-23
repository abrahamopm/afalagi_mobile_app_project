import '../../domain/entities/admin_stats.dart';

class AdminStatsModel extends AdminStats {
  const AdminStatsModel({
    required super.userCount,
    required super.propertyCount,
    required super.viewingCount,
    required super.pendingUsers,
    required super.hiddenProperties,
    required List<AdminActivityModel> super.recentActivity,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final recent = (json['recentActivity'] as List? ?? [])
        .map((a) => AdminActivityModel.fromJson(a as Map<String, dynamic>))
        .toList();

    return AdminStatsModel(
      userCount: json['userCount'] ?? 0,
      propertyCount: json['propertyCount'] ?? 0,
      viewingCount: json['viewingCount'] ?? 0,
      pendingUsers: json['pendingUsers'] ?? 0,
      hiddenProperties: json['hiddenProperties'] ?? 0,
      recentActivity: recent,
    );
  }
}

class AdminActivityModel extends AdminActivity {
  const AdminActivityModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.time,
  });

  factory AdminActivityModel.fromJson(Map<String, dynamic> json) {
    return AdminActivityModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time']?.toString() ?? '',
    );
  }
}
