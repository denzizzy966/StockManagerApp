import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stock_item.dart';
import '../providers/stock_provider.dart';

class AddStockDialog extends StatefulWidget {
  final StockItem? item;

  const AddStockDialog({super.key, this.item});

  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _minStockController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name);
    _barcodeController = TextEditingController(text: widget.item?.barcode);
    _quantityController = TextEditingController(
        text: widget.item?.quantity.toString());
    _priceController = TextEditingController(
        text: widget.item?.price.toString());
    _minStockController = TextEditingController(
        text: widget.item?.minStockLevel.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a barcode';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _minStockController,
                decoration: const InputDecoration(labelText: 'Minimum Stock Level'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a minimum stock level';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(widget.item == null ? 'Add' : 'Save'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final stockProvider =
                  Provider.of<StockProvider>(context, listen: false);

              final item = StockItem(
                id: widget.item?.id,
                name: _nameController.text,
                barcode: _barcodeController.text,
                quantity: int.parse(_quantityController.text),
                price: double.parse(_priceController.text),
                minStockLevel: int.parse(_minStockController.text),
                lastUpdated: DateTime.now(),
              );

              if (widget.item == null) {
                await stockProvider.addItem(item);
              } else {
                await stockProvider.updateItem(item);
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ],
    );
  }
}
