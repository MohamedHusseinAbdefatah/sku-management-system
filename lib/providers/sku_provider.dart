import 'package:flutter/foundation.dart';
import 'package:flutter_application_31/models/sku_model.dart';
import 'package:flutter_application_31/services/db_helper.dart';

// import 'package:flutter/foundation.dart';
// import 'package:sku_managment/models/sku_model.dart';
// // providers/sku_provider.dart

// class SKUProvider with ChangeNotifier {
//   List<SKU> _skus = [];

//   List<SKU> get skus => _skus;

//   // Add these getters for active/inactive SKUs
//   List<SKU> get activeSKUs => _skus.where((sku) => sku.isActive).toList();
//   List<SKU> get inactiveSKUs => _skus.where((sku) => !sku.isActive).toList();

//   // Existing search method (unchanged)
//   List<SKU> searchSKUs(String query) {
//     if (query.isEmpty) return _skus;
//     return _skus.where((sku) {
//       return sku.code.toLowerCase().contains(query.toLowerCase()) ||
//           sku.itemName.toLowerCase().contains(query.toLowerCase()) ||
//           sku.category.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//   }

//   // Add this method to toggle SKU status
//   // providers/sku_provider.dart (toggleSKUStatus)
//   void toggleSKUStatus(String skuCode) {
//     final index = _skus.indexWhere((sku) => sku.code == skuCode);
//     if (index != -1) {
//       _skus[index].isActive = !_skus[index].isActive;
//       _skus[index].deactivationDate =
//           _skus[index].isActive ? null : DateTime.now(); // Correctly set date
//       notifyListeners();
//     }
//   }

//   void updateStock(String skuCode, int newQuantity) {
//     final index = _skus.indexWhere((sku) => sku.code == skuCode);
//     if (index != -1) {
//       _skus[index].quantity = newQuantity;
//       notifyListeners();
//     }
//   }

//   // Adjust reserved stock
//  void reserveStock(String skuCode, int quantity) {
//     final index = _skus.indexWhere((sku) => sku.code == skuCode);
//     if (index != -1) {
//       final sku = _skus[index];
//       if (sku.reservedStock + quantity > sku.quantity ||
//           sku.reservedStock + quantity < 0) {
//         throw ArgumentError(
//             'Reserved stock cannot exceed quantity or be negative. '
//             'Current reserved: ${sku.reservedStock}, quantity: ${sku.quantity}');
//       }
//       sku.reservedStock += quantity;
//       notifyListeners();
//     }
//   }

//   // Set reorder threshold
//   void setReorderThreshold(String skuCode, int threshold) {
//     final index = _skus.indexWhere((sku) => sku.code == skuCode);
//     if (index != -1) {
//       _skus[index].reorderThreshold = threshold;
//       notifyListeners();
//     }
//   }

//   // Existing addSKU method (unchanged)
//   void addSKU(SKU sku) {
//     _skus.add(sku);
//     notifyListeners();
//   }
// }

class SKUProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<SKU> _skus = [];

  List<SKU> get skus => _skus;
  List<SKU> get activeSKUs => _skus.where((sku) => sku.isActive).toList();
  List<SKU> get inactiveSKUs => _skus.where((sku) => !sku.isActive).toList();

  Future<void> loadSKUs() async {
    _skus = await _dbHelper.getAllSKUs();
    notifyListeners();
  }

  List<SKU> searchSKUs(String query) {
    if (query.isEmpty) return _skus;
    return _skus.where((sku) {
      return sku.code.toLowerCase().contains(query.toLowerCase()) ||
          sku.itemName.toLowerCase().contains(query.toLowerCase()) ||
          sku.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> addSKU(SKU sku) async {
    await _dbHelper.insertSKU(sku);
    await loadSKUs();
  }

  Future<void> toggleSKUStatus(String skuCode) async {
    final sku = _skus.firstWhere((s) => s.code == skuCode);
    sku.isActive = !sku.isActive;
    sku.deactivationDate = sku.isActive ? null : DateTime.now();
    await _dbHelper.updateSKU(sku);
    await loadSKUs();
  }

  Future<void> updateStock(String skuCode, int newQuantity) async {
    final sku = _skus.firstWhere((s) => s.code == skuCode);
    sku.quantity = newQuantity;
    await _dbHelper.updateSKU(sku);
    await loadSKUs();
  }

  Future<void> reserveStock(String skuCode, int quantity) async {
    final sku = _skus.firstWhere((s) => s.code == skuCode);
    if (sku.reservedStock + quantity > sku.quantity ||
        sku.reservedStock + quantity < 0) {
      throw ArgumentError(
        'Reserved stock cannot exceed quantity or be negative. '
        'Current reserved: ${sku.reservedStock}, quantity: ${sku.quantity}',
      );
    }
    sku.reservedStock += quantity;
    await _dbHelper.updateSKU(sku);
    await loadSKUs();
  }

  Future<void> setReorderThreshold(String skuCode, int threshold) async {
    final sku = _skus.firstWhere((s) => s.code == skuCode);
    sku.reorderThreshold = threshold;
    await _dbHelper.updateSKU(sku);
    await loadSKUs();
  }
}
