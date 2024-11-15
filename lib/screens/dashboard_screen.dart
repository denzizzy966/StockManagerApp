import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/stock_provider.dart';
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
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, child) {
          final items = stockProvider.items;
          final lowStockItems = stockProvider.lowStockItems;

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
                        title: 'Low Stock',
                        value: lowStockItems.length.toString(),
                        icon: Icons.warning,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Stock Level Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: items.isEmpty ? 100 : items.map((e) => e.quantity.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= items.length) return const Text('');
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  items[value.toInt()].name.substring(0, 3),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        items.length > 10 ? 10 : items.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: items[index].quantity.toDouble(),
                              color: items[index].quantity <= items[index].minStockLevel
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
}
