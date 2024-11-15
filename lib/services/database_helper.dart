import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stock_item.dart';
import '../models/warehouse.dart';
import '../models/stock_history.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stock_manager.db');
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
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        barcode TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        minStockLevel INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL,
        warehouseId TEXT NOT NULL,
        warehouseName TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE warehouses(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE history(
        id TEXT PRIMARY KEY,
        itemId TEXT NOT NULL,
        itemName TEXT NOT NULL,
        warehouseId TEXT NOT NULL,
        warehouseName TEXT NOT NULL,
        quantityChange INTEGER NOT NULL,
        type TEXT NOT NULL,
        notes TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<List<StockItem>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => StockItem.fromMap(maps[i]));
  }

  Future<List<Warehouse>> getAllWarehouses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('warehouses');
    return List.generate(maps.length, (i) => Warehouse.fromJson(maps[i]));
  }

  Future<List<StockHistory>> getAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => StockHistory.fromJson(maps[i]));
  }

  Future<int> insertItem(StockItem item) async {
    final db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<int> insertWarehouse(Warehouse warehouse) async {
    final db = await database;
    return await db.insert('warehouses', warehouse.toJson());
  }

  Future<void> insertHistory(StockHistory history) async {
    final db = await database;
    await db.insert('history', history.toJson());
  }

  Future<int> updateItem(StockItem item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> updateWarehouse(Warehouse warehouse) async {
    final db = await database;
    return await db.update(
      'warehouses',
      warehouse.toJson(),
      where: 'id = ?',
      whereArgs: [warehouse.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWarehouse(String id) async {
    final db = await database;
    return await db.delete(
      'warehouses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
