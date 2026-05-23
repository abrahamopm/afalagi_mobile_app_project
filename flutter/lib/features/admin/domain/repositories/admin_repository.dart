import '../entities/admin_property_item.dart';
import '../entities/admin_stats.dart';
import '../entities/admin_user_summary.dart';

abstract class AdminRepository {
  Future<AdminStats> getStats();
  Future<List<AdminUserSummary>> getUsers();
  Future<AdminUserSummary> updateUser(String id, {bool? isActive, bool? isVerified});
  Future<List<AdminPropertyItem>> getProperties();
  Future<AdminPropertyItem> updateProperty(String id, {bool? isAvailable});
  Future<void> deleteProperty(String id);
}
