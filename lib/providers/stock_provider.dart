import 'package:flutter/foundation.dart';
import '../models/stock_item.dart';
import '../services/database_helper.dart';

class StockProvider with ChangeNotifier {
  List<StockItem> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<StockItem> get items => _items;
  List<StockItem> get lowStockItems => _items.where((item) => item.quantity <= item.minStockLevel).toList();

  Future<void> loadItems() async {
    _items = await _dbHelper.getAllItems();
    notifyListeners();
  }

  Future<void> addItem(StockItem item) async {
    final id = await _dbHelper.insertItem(item);
    final newItem = item.copyWith(id: id);
    _items.add(newItem);
    notifyListeners();
  }

  Future<void> updateItem(StockItem item) async {
    await _dbHelper.updateItem(item);
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> updateQuantity(int id, int newQuantity) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index].copyWith(
        quantity: newQuantity,
        lastUpdated: DateTime.now(),
      );
      await _dbHelper.updateItem(item);
      _items[index] = item;
      notifyListeners();
    }
  }

  StockItem? findByBarcode(String barcode) {
    try {
      return _items.firstWhere((item) => item.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
}
