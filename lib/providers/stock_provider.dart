import 'package:flutter/foundation.dart';
import '../models/stock_item.dart';
import '../models/stock_history.dart';
import '../services/database_helper.dart';

class StockProvider with ChangeNotifier {
  List<StockItem> _items = [];
  List<StockHistory> _history = [];
  
  List<StockItem> get items => [..._items];
  List<StockHistory> get history => [..._history];
  
  List<StockItem> get lowStockItems => _items.where((item) => item.quantity <= item.minStockLevel).toList();

  Future<void> loadItems() async {
    final db = DatabaseHelper.instance;
    final items = await db.getAllItems();
    _items = items;
    notifyListeners();
    
    final history = await db.getAllHistory();
    _history = history;
    notifyListeners();
  }

  Future<void> addItem(StockItem item) async {
    final db = DatabaseHelper.instance;
    final id = await db.insertItem(item);
    final newItem = item.copyWith(id: id);
    _items.add(newItem);
    
    // Add to history
    final history = StockHistory(
      id: DateTime.now().toString(),
      itemId: id.toString(),
      itemName: item.name,
      warehouseId: item.warehouseId,
      warehouseName: item.warehouseName,
      quantityChange: item.quantity,
      type: 'in',
      notes: 'Initial stock',
      timestamp: DateTime.now(),
    );
    await db.insertHistory(history);
    _history.add(history);
    
    notifyListeners();
  }

  Future<void> updateItem(StockItem item) async {
    final db = DatabaseHelper.instance;
    await db.updateItem(item);
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      final oldQuantity = _items[index].quantity;
      final quantityChange = item.quantity - oldQuantity;
      
      _items[index] = item;
      
      // Add to history if quantity changed
      if (quantityChange != 0) {
        final history = StockHistory(
          id: DateTime.now().toString(),
          itemId: item.id.toString(),
          itemName: item.name,
          warehouseId: item.warehouseId,
          warehouseName: item.warehouseName,
          quantityChange: quantityChange,
          type: quantityChange > 0 ? 'in' : 'out',
          notes: 'Stock update',
          timestamp: DateTime.now(),
        );
        await db.insertHistory(history);
        _history.add(history);
      }
      
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteItem(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> updateStock(int id, int quantity) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final item = _items[index];
      final newItem = item.copyWith(
        quantity: quantity,
        lastUpdated: DateTime.now(),
      );
      await updateItem(newItem);
    }
  }
}
