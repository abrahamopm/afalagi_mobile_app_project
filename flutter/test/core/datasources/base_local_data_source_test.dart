import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:afalagi/core/database/database_helper.dart';
import 'package:afalagi/core/database/database_tables.dart';
import 'package:afalagi/core/datasources/base_local_data_source.dart';
import 'package:afalagi/features/property/data/models/property_model.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockDatabase extends Mock implements Database {}
class MockTransaction extends Mock implements Transaction {}
class MockBatch extends Mock implements Batch {}

class TestLocalDataSource extends BaseLocalDataSource<PropertyModel> {
  TestLocalDataSource({required super.dbHelper})
      : super(
          tableName: DatabaseTables.properties,
          fromMap: PropertyModel.fromMap,
          toMap: (item) => item.toMap(),
        );
}

void main() {
  late MockDatabaseHelper mockDbHelper;
  late MockDatabase mockDb;
  late MockTransaction mockTransaction;
  late MockBatch mockBatch;
  late TestLocalDataSource dataSource;

  const tPropertyModel = PropertyModel(
    id: '1',
    title: 'Test Property',
    description: 'Test Description',
    location: 'Test Location',
    imageUrl: 'test.png',
    price: 1000.0,
    beds: 1,
    baths: 1,
    sqft: 100,
    isAvailable: true,
    tags: [],
  );

  setUpAll(() {
    registerFallbackValue(tPropertyModel);
  });

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    mockDb = MockDatabase();
    mockTransaction = MockTransaction();
    mockBatch = MockBatch();
    dataSource = TestLocalDataSource(dbHelper: mockDbHelper);

    when(() => mockDbHelper.database).thenAnswer((_) async => mockDb);

    when(() => mockDb.transaction<void>(any())).thenAnswer((invocation) async {
      final callback = invocation.positionalArguments[0] as Function;
      await callback(mockTransaction);
    });
    when(() => mockDb.transaction<Null>(any())).thenAnswer((invocation) async {
      final callback = invocation.positionalArguments[0] as Function;
      await callback(mockTransaction);
      return null;
    });
    when(() => mockDb.transaction<dynamic>(any())).thenAnswer((invocation) async {
      final callback = invocation.positionalArguments[0] as Function;
      return await callback(mockTransaction);
    });
  });

  group('BaseLocalDataSource Tests', () {
    test('getCached should return a list of items from the database', () async {
      // arrange
      final List<Map<String, dynamic>> maps = [
        tPropertyModel.toMap(),
      ];
      when(() => mockDb.query(any())).thenAnswer((_) async => maps);

      // act
      final result = await dataSource.getCached();

      // assert
      expect(result, equals([tPropertyModel]));
      verify(() => mockDb.query(DatabaseTables.properties)).called(1);
    });

    test('getCachedById should return an item when found in the database', () async {
      // arrange
      final List<Map<String, dynamic>> maps = [
        tPropertyModel.toMap(),
      ];
      when(() => mockDb.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => maps);

      // act
      final result = await dataSource.getCachedById('1');

      // assert
      expect(result, equals(tPropertyModel));
      verify(() => mockDb.query(
            DatabaseTables.properties,
            where: 'id = ?',
            whereArgs: ['1'],
          )).called(1);
    });

    test('getCachedById should return null when not found', () async {
      // arrange
      when(() => mockDb.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => <Map<String, dynamic>>[]);

      // act
      final result = await dataSource.getCachedById('1');

      // assert
      expect(result, isNull);
    });

    test('removeOne should delete the item from the database', () async {
      // arrange
      when(() => mockDb.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.removeOne('1');

      // assert
      verify(() => mockDb.delete(
            DatabaseTables.properties,
            where: 'id = ?',
            whereArgs: ['1'],
          )).called(1);
    });

    test('cacheOne should run transaction and save item', () async {
      // arrange
      when(() => mockTransaction.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.cacheOne(tPropertyModel);

      // assert
      verify(() => mockTransaction.insert(
            DatabaseTables.properties,
            tPropertyModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).called(1);
      verify(() => mockTransaction.insert(
            DatabaseTables.cacheMetadata,
            any(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).called(1);
    });

    test('cacheAll should run transaction, delete table and commit batch', () async {
      // arrange
      when(() => mockTransaction.delete(any())).thenAnswer((_) async => 1);
      when(() => mockTransaction.batch()).thenReturn(mockBatch);
      when(() => mockBatch.commit(noResult: any(named: 'noResult'))).thenAnswer((_) async => []);
      when(() => mockTransaction.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.cacheAll([tPropertyModel]);

      // assert
      verify(() => mockTransaction.delete(DatabaseTables.properties)).called(1);
      verify(() => mockBatch.insert(
            DatabaseTables.properties,
            tPropertyModel.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).called(1);
      verify(() => mockBatch.commit(noResult: true)).called(1);
      verify(() => mockTransaction.insert(
            DatabaseTables.cacheMetadata,
            any(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).called(1);
    });

    test('clearCache should run transaction and delete data', () async {
      // arrange
      when(() => mockTransaction.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => 1);

      // act
      await dataSource.clearCache();

      // assert
      verify(() => mockTransaction.delete(DatabaseTables.properties)).called(1);
      verify(() => mockTransaction.delete(
            DatabaseTables.cacheMetadata,
            where: '${DatabaseTables.colMetadataTable} = ?',
            whereArgs: [DatabaseTables.properties],
          )).called(1);
    });

    test('isCacheValid should return true if metadata exists and time diff < TTL', () async {
      // arrange
      final now = DateTime.now().millisecondsSinceEpoch;
      final resultList = [
        {
          DatabaseTables.colMetadataTable: DatabaseTables.properties,
          DatabaseTables.colMetadataLastUpdated: now - 1000, // 1 second ago
        }
      ];

      when(() => mockDb.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => resultList);

      // act
      final result = await dataSource.isCacheValid();

      // assert
      expect(result, isTrue);
    });

    test('isCacheValid should return false if last updated is older than TTL', () async {
      // arrange
      final now = DateTime.now().millisecondsSinceEpoch;
      final resultList = [
        {
          DatabaseTables.colMetadataTable: DatabaseTables.properties,
          DatabaseTables.colMetadataLastUpdated: now - DatabaseTables.cacheTtlMs - 1000,
        }
      ];

      when(() => mockDb.query(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          )).thenAnswer((_) async => resultList);

      // act
      final result = await dataSource.isCacheValid();

      // assert
      expect(result, isFalse);
    });
  });
}
