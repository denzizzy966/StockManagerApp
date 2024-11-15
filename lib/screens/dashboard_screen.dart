import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../providers/warehouse_provider.dart';
import '../widgets/stock_summary_card.dart';
import '../widgets/low_stock_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Consumer2<StockProvider, WarehouseProvider>(
        builder: (context, stockProvider, warehouseProvider, child) {
          final items = stockProvider.items;
          final lowStockItems = stockProvider.lowStockItems;
          final warehouses = warehouseProvider.warehouses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StockSummaryCard(
                        title: 'Total Items',
                        value: items.length.toString(),
                        icon: Icons.inventory,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StockSummaryCard(
                        title: 'Low Stock Items',
                        value: lowStockItems.length.toString(),
                        icon: Icons.warning,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StockSummaryCard(
                        title: 'Total Warehouses',
                        value: warehouses.length.toString(),
                        icon: Icons.warehouse,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StockSummaryCard(
                        title: 'Total Stock Value',
                        value: '\$${_calculateTotalValue(items)}',
                        icon: Icons.attach_money,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Low Stock Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                LowStockList(items: lowStockItems),
              ],
            ),
          );
        },
      ),
    );
  }

  String _calculateTotalValue(List<dynamic> items) {
    double total = 0;
    for (var item in items) {
      total += (item.price ?? 0) * item.quantity;
    }
    return total.toStringAsFixed(2);
  }
}
