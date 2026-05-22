import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/database_tables.dart';

abstract class BaseLocalDataSource<T> {
  final DatabaseHelper dbHelper;
  final String tableName;
  final String idColumn;
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T item) toMap;

  BaseLocalDataSource({
    required this.dbHelper,
    required this.tableName,
    this.idColumn = 'id',
    required this.fromMap,
    required this.toMap,
  });

  Future<List<T>> getCached() async {
    final db = await dbHelper.database;
    final maps = await db.query(tableName);
    return maps.map((m) => fromMap(m)).toList();
  }

  Future<T?> getCachedById(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<void> cacheAll(List<T> items) async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      // Clear current table
      await txn.delete(tableName);
      
      // Batch insert
      final batch = txn.batch();
      for (final item in items) {
        batch.insert(
          tableName,
          toMap(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);

      // Update cache metadata
      await txn.insert(
        DatabaseTables.cacheMetadata,
        {
          DatabaseTables.colMetadataTable: tableName,
          DatabaseTables.colMetadataLastUpdated: DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> cacheOne(T item) async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      await txn.insert(
        tableName,
        toMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await txn.insert(
        DatabaseTables.cacheMetadata,
        {
          DatabaseTables.colMetadataTable: tableName,
          DatabaseTables.colMetadataLastUpdated: DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> removeOne(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCache() async {
    final db = await dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete(tableName);
      await txn.delete(
        DatabaseTables.cacheMetadata,
        where: '${DatabaseTables.colMetadataTable} = ?',
        whereArgs: [tableName],
      );
    });
  }

  Future<bool> isCacheValid({int ttlMs = DatabaseTables.cacheTtlMs}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseTables.cacheMetadata,
      where: '${DatabaseTables.colMetadataTable} = ?',
      whereArgs: [tableName],
    );
    if (result.isEmpty) return false;
    final lastUpdated = result.first[DatabaseTables.colMetadataLastUpdated] as int;
    final diff = DateTime.now().millisecondsSinceEpoch - lastUpdated;
    return diff < ttlMs;
  }
}
