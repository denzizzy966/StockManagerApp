import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stock_item.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'stock_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE stock_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        barcode TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        minStockLevel INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertItem(StockItem item) async {
    final db = await database;
    return await db.insert('stock_items', item.toMap());
  }

  Future<List<StockItem>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stock_items');
    return List.generate(maps.length, (i) => StockItem.fromMap(maps[i]));
  }

  Future<int> updateItem(StockItem item) async {
    final db = await database;
    return await db.update(
      'stock_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'stock_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
