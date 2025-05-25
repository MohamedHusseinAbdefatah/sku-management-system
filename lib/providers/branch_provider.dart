import 'package:flutter/foundation.dart';
import 'package:flutter_application_31/models/brach_model.dart';
import 'package:flutter_application_31/services/db_helper.dart';

// import 'package:flutter/foundation.dart';
// import 'package:sku_managment/models/brach_model.dart';

// class BranchProvider with ChangeNotifier {
//   final List<InventoryBranch> _branches = [];

//   List<InventoryBranch> get branches => _branches;

//  void addBranch(InventoryBranch branch) {
//     final exists = _branches.any((b) => b.id == branch.id);
//     if (exists) {
//       throw ArgumentError('Branch ID ${branch.id} already exists');
//     }
//     _branches.add(branch);
//     notifyListeners();
//   }

//   void deleteBranch(String branchId) {
//     _branches.removeWhere((branch) => branch.id == branchId);
//     notifyListeners();
//   }
// }

class BranchProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<InventoryBranch> _branches = [];

  List<InventoryBranch> get branches => _branches;

  Future<void> loadBranches() async {
    _branches = await _dbHelper.getAllBranches();
    notifyListeners();
  }

  Future<void> addBranch(InventoryBranch branch) async {
    if (_branches.any((b) => b.id == branch.id)) {
      throw ArgumentError('Branch ID ${branch.id} already exists');
    }
    await _dbHelper.insertBranch(branch);
    await loadBranches();
  }

  Future<void> deleteBranch(String branchId) async {
    await _dbHelper.deleteBranch(branchId);
    await loadBranches();
  }

  // In BranchProvider class
  Future<void> updateBranch(InventoryBranch updatedBranch) async {
    await _dbHelper.updateBranch(updatedBranch);
    await loadBranches();
  }

  InventoryBranch? getBranchById(String id) {
    try {
      return _branches.firstWhere((branch) => branch.id == id);
    } catch (e) {
      return null;
    }
  }
}
