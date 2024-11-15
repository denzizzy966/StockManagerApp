class StockHistory {
  final String id;
  final String itemId;
  final String itemName;
  final String warehouseId;
  final String warehouseName;
  final int quantityChange;
  final String type; // 'in' or 'out'
  final String notes;
  final DateTime timestamp;

  StockHistory({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.warehouseId,
    required this.warehouseName,
    required this.quantityChange,
    required this.type,
    required this.notes,
    required this.timestamp,
  });

  factory StockHistory.fromJson(Map<String, dynamic> json) {
    return StockHistory(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      warehouseId: json['warehouseId'] as String,
      warehouseName: json['warehouseName'] as String,
      quantityChange: json['quantityChange'] as int,
      type: json['type'] as String,
      notes: json['notes'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'itemName': itemName,
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
      'quantityChange': quantityChange,
      'type': type,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
