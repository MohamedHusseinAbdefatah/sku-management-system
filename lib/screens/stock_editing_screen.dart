import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_31/models/sku_model.dart';
import 'package:flutter_application_31/providers/sku_provider.dart';

class StockEditScreen extends StatefulWidget {
  final SKU sku;
  const StockEditScreen({super.key, required this.sku});

  @override
  _StockEditScreenState createState() => _StockEditScreenState();
}

class _StockEditScreenState extends State<StockEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _quantity;
  late int _reservedStock;
  late int _reorderThreshold;

  @override
  void initState() {
    super.initState();
    _quantity = widget.sku.quantity;
    _reservedStock = widget.sku.reservedStock;
    _reorderThreshold = widget.sku.reorderThreshold;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<SKUProvider>(context, listen: false);
      provider.updateStock(widget.sku.code, _quantity);
      provider.reserveStock(widget.sku.code, _reservedStock);
      provider.setReorderThreshold(widget.sku.code, _reorderThreshold);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Stock: ${widget.sku.code}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Total Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onChanged: (value) => _quantity = int.parse(value),
              ),
              TextFormField(
                initialValue: _reservedStock.toString(),
                decoration: const InputDecoration(labelText: 'Reserved Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onChanged: (value) => _reservedStock = int.parse(value),
              ),
              TextFormField(
                initialValue: _reorderThreshold.toString(),
                decoration: const InputDecoration(
                  labelText: 'Reorder Threshold',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onChanged: (value) => _reorderThreshold = int.parse(value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
