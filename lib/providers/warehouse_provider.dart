import 'package:flutter/material.dart';
import '../models/warehouse.dart';

class WarehouseProvider with ChangeNotifier {
  List<Warehouse> _warehouses = [];
  
  List<Warehouse> get warehouses => [..._warehouses];

  Future<void> loadWarehouses() async {
    // TODO: Implement loading from database/storage
    notifyListeners();
  }

  Future<void> addWarehouse(Warehouse warehouse) async {
    // TODO: Implement adding to database/storage
    _warehouses.add(warehouse);
    notifyListeners();
  }

  Future<void> updateWarehouse(Warehouse warehouse) async {
    // TODO: Implement updating in database/storage
    final index = _warehouses.indexWhere((w) => w.id == warehouse.id);
    if (index >= 0) {
      _warehouses[index] = warehouse;
      notifyListeners();
    }
  }

  Future<void> deleteWarehouse(String id) async {
    // TODO: Implement deleting from database/storage
    _warehouses.removeWhere((w) => w.id == id);
    notifyListeners();
  }
}
