import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_application_31/models/sku_model.dart';
import 'package:flutter_application_31/providers/sku_provider.dart';

class SKUCreationScreen extends StatefulWidget {
  const SKUCreationScreen({super.key});

  @override
  _SKUCreationScreenState createState() => _SKUCreationScreenState();
}

class _SKUCreationScreenState extends State<SKUCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reorderController = TextEditingController();
  String _skuCode = '';
  String _itemName = '';
  String _category = 'Electronics';
  bool _autoGenerateSKU = true;
  bool _isActive = true;

  final _primaryColor = Colors.blue.shade800;
  final _accentColor = Colors.blue.shade100;

  String _generateSKU() {
    final prefix = _itemName.isNotEmpty
        ? _itemName.substring(0, 3).toUpperCase()
        : 'ITM';
    final categoryCode = _category.substring(0, 3).toUpperCase();
    return '$prefix-$categoryCode-${DateTime.now().millisecondsSinceEpoch % 1000}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final skuProvider = Provider.of<SKUProvider>(context, listen: false);

      if (_autoGenerateSKU) {
        _skuCode = _generateSKU();
      }

      final isDuplicate = skuProvider.skus.any((s) => s.code == _skuCode);
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('SKU code already exists!'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final sku = SKU(
        code: _skuCode,
        itemName: _itemName,
        category: _category,
        quantity: int.parse(_quantityController.text),
        reorderThreshold: int.parse(_reorderController.text),
        isActive: _isActive,
        creationDate: DateTime.now(),
      );

      try {
        skuProvider.addSKU(sku);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: Icon(Icons.check_circle, color: _primaryColor, size: 48),
            title: const Text(
              'SKU Created Successfully',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SKU Code: $_skuCode',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: _skuCode,
                  width: 200,
                  height: 80,
                  color: _primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Initial Stock: ${_quantityController.text}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: _primaryColor)),
              ),
            ],
          ),
        );
        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _skuCode = '';
    _itemName = '';
    _category = 'Electronics';
    _autoGenerateSKU = true;
    _isActive = true;
    _quantityController.clear();
    _reorderController.clear();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reorderController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New SKU'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionHeader('Product Information'),

              SwitchListTile(
                title: Text(
                  'Auto-generate SKU',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                value: _autoGenerateSKU,
                activeColor: _primaryColor,
                activeTrackColor: _accentColor,
                inactiveThumbColor: Colors.grey.shade600,
                onChanged: (value) => setState(() => _autoGenerateSKU = value),
              ),

              _buildInputField(
                label: 'Item Name',
                icon: Icons.label_outline,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
                onChanged: (value) => _itemName = value,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items: ['Electronics', 'Clothing', 'Books']
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
                validator: (value) => value == null ? 'Select category' : null,
                dropdownColor: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                icon: Icon(Icons.arrow_drop_down, color: _primaryColor),
              ),

              if (!_autoGenerateSKU) ...[
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'SKU Code',
                  icon: Icons.code_outlined,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                  onChanged: (value) => _skuCode = value,
                ),
              ],

              _buildSectionHeader('Inventory Settings'),
              _buildInputField(
                label: 'Initial Quantity',
                icon: Icons.inventory_2_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
                onChanged: (value) => _quantityController.text = value,
                controller: _quantityController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Reorder Threshold',
                icon: Icons.warning_amber_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
                onChanged: (value) => _reorderController.text = value,
                controller: _reorderController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: Text(
                  'Active Status',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                value: _isActive,
                activeColor: _primaryColor,
                activeTrackColor: _accentColor,
                inactiveThumbColor: Colors.grey.shade600,
                onChanged: (value) => setState(() => _isActive = value),
              ),

              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_box_outlined, size: 22),
                  label: const Text(
                    'Create SKU',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
