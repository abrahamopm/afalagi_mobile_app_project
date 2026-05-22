class DashboardStats {
  final int propertyCount;
  final int clientCount;
  final int viewingCount;
  final int todayViewingCount;
  final List<DashboardActivity> recentActivity;

  const DashboardStats({
    required this.propertyCount,
    required this.clientCount,
    required this.viewingCount,
    required this.todayViewingCount,
    required this.recentActivity,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardStats &&
          runtimeType == other.runtimeType &&
          propertyCount == other.propertyCount &&
          clientCount == other.clientCount &&
          viewingCount == other.viewingCount &&
          todayViewingCount == other.todayViewingCount &&
          recentActivity.toString() == other.recentActivity.toString();

  @override
  int get hashCode =>
      propertyCount.hashCode ^
      clientCount.hashCode ^
      viewingCount.hashCode ^
      todayViewingCount.hashCode ^
      recentActivity.toString().hashCode;
}

class DashboardActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;

  const DashboardActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardActivity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          description == other.description &&
          time == other.time;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      title.hashCode ^
      description.hashCode ^
      time.hashCode;
}
