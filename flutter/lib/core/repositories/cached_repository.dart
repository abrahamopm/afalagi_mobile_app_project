import '../datasources/base_local_data_source.dart';
import '../datasources/base_remote_data_source.dart';
import '../errors/exceptions.dart';
import '../network/network_info.dart';

abstract class CachedRepository<Entity, Model extends Entity> {
  final BaseRemoteDataSource<Model> remote;
  final BaseLocalDataSource<Model> local;
  final NetworkInfo networkInfo;

  CachedRepository({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  Future<List<Entity>> getAll() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remote.getAll();
        await local.cacheAll(items);
        return items;
      } on ServerException {
        final cached = await local.getCached();
        if (cached.isNotEmpty) return cached;
        rethrow;
      }
    }
    final cached = await local.getCached();
    if (cached.isNotEmpty) return cached;
    throw const ServerException(message: 'No internet connection and no cached data.');
  }

  Future<Entity> getById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final item = await remote.getById(id);
        await local.cacheOne(item);
        return item;
      } on ServerException {
        final cached = await local.getCachedById(id);
        if (cached != null) return cached;
        rethrow;
      }
    }
    final cached = await local.getCachedById(id);
    if (cached != null) return cached;
    throw const ServerException(message: 'No internet connection and no cached data.');
  }

  Future<Entity> create(Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      final model = await remote.create(body);
      await local.cacheOne(model);
      return model;
    }
    throw const ServerException(message: 'Cannot create record offline.');
  }

  Future<Entity> update(String id, Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      final model = await remote.update(id, body);
      await local.cacheOne(model);
      return model;
    }
    throw const ServerException(message: 'Cannot update record offline.');
  }

  Future<void> delete(String id) async {
    if (await networkInfo.isConnected) {
      await remote.delete(id);
      await local.removeOne(id);
      return;
    }
    throw const ServerException(message: 'Cannot delete record offline.');
  }
}
