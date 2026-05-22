import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database_tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('afalagi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Cache Metadata table
    await db.execute('''
      CREATE TABLE ${DatabaseTables.cacheMetadata} (
        ${DatabaseTables.colMetadataTable} TEXT PRIMARY KEY,
        ${DatabaseTables.colMetadataLastUpdated} INTEGER NOT NULL
      )
    ''');

    // 2. Properties table
    await db.execute('''
      CREATE TABLE ${DatabaseTables.properties} (
        ${DatabaseTables.colPropId} TEXT PRIMARY KEY,
        ${DatabaseTables.colPropTitle} TEXT NOT NULL,
        ${DatabaseTables.colPropDescription} TEXT NOT NULL,
        ${DatabaseTables.colPropLocation} TEXT NOT NULL,
        ${DatabaseTables.colPropImageUrl} TEXT NOT NULL,
        ${DatabaseTables.colPropPrice} REAL NOT NULL,
        ${DatabaseTables.colPropBeds} INTEGER NOT NULL,
        ${DatabaseTables.colPropBaths} INTEGER NOT NULL,
        ${DatabaseTables.colPropSqft} INTEGER NOT NULL,
        ${DatabaseTables.colPropIsAvailable} INTEGER NOT NULL,
        ${DatabaseTables.colPropTags} TEXT NOT NULL
      )
    '''' + ');' // Adding semicolon for standard formatting
    );

    // 3. Clients table
    await db.execute('''
      CREATE TABLE ${DatabaseTables.clients} (
        ${DatabaseTables.colClientId} TEXT PRIMARY KEY,
        ${DatabaseTables.colClientName} TEXT NOT NULL,
        ${DatabaseTables.colClientPhone} TEXT NOT NULL,
        ${DatabaseTables.colClientPriority} TEXT NOT NULL,
        ${DatabaseTables.colClientInterest} INTEGER NOT NULL,
        ${DatabaseTables.colClientArea} TEXT NOT NULL,
        ${DatabaseTables.colClientBudget} TEXT NOT NULL,
        ${DatabaseTables.colClientImage} TEXT NOT NULL,
        ${DatabaseTables.colClientTags} TEXT NOT NULL
      )
    ''');

    // 4. Viewings table
    await db.execute('''
      CREATE TABLE ${DatabaseTables.viewings} (
        ${DatabaseTables.colViewingId} TEXT PRIMARY KEY,
        ${DatabaseTables.colViewingPropertyId} TEXT NOT NULL,
        ${DatabaseTables.colViewingClientId} TEXT NOT NULL,
        ${DatabaseTables.colViewingPropertyTitle} TEXT NOT NULL,
        ${DatabaseTables.colViewingClientName} TEXT NOT NULL,
        ${DatabaseTables.colViewingImageUrl} TEXT NOT NULL,
        ${DatabaseTables.colViewingDate} TEXT NOT NULL,
        ${DatabaseTables.colViewingStatus} TEXT NOT NULL,
        ${DatabaseTables.colViewingPrice} TEXT NOT NULL,
        ${DatabaseTables.colViewingNotes} TEXT NOT NULL
      )
    ''');

    // 5. Tags table
    await db.execute('''
      CREATE TABLE ${DatabaseTables.tags} (
        ${DatabaseTables.colTagId} TEXT PRIMARY KEY,
        ${DatabaseTables.colTagName} TEXT NOT NULL,
        ${DatabaseTables.colTagColor} TEXT NOT NULL,
        ${DatabaseTables.colTagPropertyCount} INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
