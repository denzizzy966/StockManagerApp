import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/warehouse.dart';
import '../providers/warehouse_provider.dart';

class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showWarehouseDialog(context),
          ),
        ],
      ),
      body: Consumer<WarehouseProvider>(
        builder: (context, provider, child) {
          final warehouses = provider.warehouses;
          return ListView.builder(
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return ListTile(
                title: Text(warehouse.name),
                subtitle: Text(warehouse.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showWarehouseDialog(context, warehouse),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteWarehouse(context, warehouse.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showWarehouseDialog(BuildContext context, [Warehouse? warehouse]) {
    final nameController = TextEditingController(text: warehouse?.name);
    final locationController = TextEditingController(text: warehouse?.location);
    final descriptionController = TextEditingController(text: warehouse?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(warehouse == null ? 'Add Warehouse' : 'Edit Warehouse'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<WarehouseProvider>(context, listen: false);
              final newWarehouse = Warehouse(
                id: warehouse?.id ?? DateTime.now().toString(),
                name: nameController.text,
                location: locationController.text,
                description: descriptionController.text,
              );

              if (warehouse == null) {
                provider.addWarehouse(newWarehouse);
              } else {
                provider.updateWarehouse(newWarehouse);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteWarehouse(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Warehouse'),
        content: const Text('Are you sure you want to delete this warehouse?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<WarehouseProvider>(context, listen: false)
                  .deleteWarehouse(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
