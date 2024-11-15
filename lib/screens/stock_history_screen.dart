import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../models/stock_history.dart';
import 'package:intl/intl.dart';

class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History'),
      ),
      body: Consumer<StockProvider>(
        builder: (context, provider, child) {
          final history = provider.history;
          
          if (history.isEmpty) {
            return const Center(
              child: Text('No history available'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    item.type == 'in' ? Icons.add_circle : Icons.remove_circle,
                    color: item.type == 'in' ? Colors.green : Colors.red,
                  ),
                  title: Text(item.itemName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Warehouse: ${item.warehouseName}'),
                      Text('Quantity: ${item.type == 'in' ? '+' : '-'}${item.quantityChange.abs()}'),
                      Text('Notes: ${item.notes}'),
                      Text(
                        'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(item.timestamp)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
