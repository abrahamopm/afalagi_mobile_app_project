class AdminStats {
  final int userCount;
  final int propertyCount;
  final int viewingCount;
  final int pendingUsers;
  final int hiddenProperties;
  final List<AdminActivity> recentActivity;

  const AdminStats({
    required this.userCount,
    required this.propertyCount,
    required this.viewingCount,
    required this.pendingUsers,
    required this.hiddenProperties,
    required this.recentActivity,
  });
}

class AdminActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final String time;

  const AdminActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.time,
  });
}
