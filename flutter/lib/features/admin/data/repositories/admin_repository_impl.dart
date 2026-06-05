import '../../domain/entities/admin_property_item.dart';
import '../../domain/entities/admin_stats.dart';
import '../../domain/entities/admin_user_summary.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_ds.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDS _remote;

  AdminRepositoryImpl(this._remote);

  @override
  Future<AdminStats> getStats() => _remote.getStats();

  @override
  Future<List<AdminUserSummary>> getUsers() => _remote.getUsers();

  @override
  Future<AdminUserSummary> updateUser(
    String id, {
    bool? isActive,
    bool? isVerified,
  }) =>
      _remote.updateUser(id, isActive: isActive, isVerified: isVerified);

  @override
  Future<List<AdminPropertyItem>> getProperties() => _remote.getProperties();

  @override
  Future<AdminPropertyItem> updateProperty(String id, {bool? isAvailable}) =>
      _remote.updateProperty(id, isAvailable: isAvailable);

  @override
  Future<void> deleteProperty(String id) => _remote.deleteProperty(id);
}
