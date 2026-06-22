import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pro_informatique_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Handle schema migration or recreation
      await db.execute('DROP TABLE IF EXISTS services');
      await db.execute('DROP TABLE IF EXISTS products');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    // Services with categories and detailed pricing
    await db.execute('''
      CREATE TABLE services (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        long_description TEXT,
        icon_code INTEGER NOT NULL,
        category TEXT NOT NULL,
        price_range TEXT,
        features TEXT NOT NULL,
        delivery_time TEXT
      )
    ''');

    // Products with stock and specific brand info
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price_display TEXT NOT NULL,
        price_value REAL NOT NULL,
        image_url TEXT NOT NULL,
        rating REAL NOT NULL,
        brand TEXT,
        stock_status TEXT, -- 'In Stock', 'Out of Stock', 'Limited'
        description TEXT
      )
    ''');

    // Orders for tracking
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        service_id TEXT,
        product_id TEXT,
        status TEXT NOT NULL, -- 'Pending', 'In Production', 'Ready', 'Delivered'
        total_price REAL NOT NULL,
        created_at TEXT NOT NULL,
        file_path TEXT
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
