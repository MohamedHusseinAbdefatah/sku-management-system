import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_31/models/sku_model.dart';
import 'package:flutter_application_31/models/brach_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'sku_management.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE skus(
        code TEXT PRIMARY KEY,
        itemName TEXT,
        category TEXT,
        isActive INTEGER,
        deactivationDate TEXT,
        creationDate TEXT,
        quantity INTEGER,
        reservedStock INTEGER,
        reorderThreshold INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE branches(
        id TEXT PRIMARY KEY,
        name TEXT,
        location TEXT,
        contact TEXT
      )
    ''');
  }

  // SKU Operations
  Future<int> insertSKU(SKU sku) async {
    final db = await database;
    return db.insert('skus', sku.toMap());
  }

  Future<List<SKU>> getAllSKUs() async {
    final db = await database;
    final maps = await db.query('skus');
    return List.generate(maps.length, (i) => SKU.fromMap(maps[i]));
  }

  Future<int> deleteSKU(String code) async {
    final db = await database;

    return await db.delete('skus', where: 'code = ?', whereArgs: [code]);
  }

  Future<SKU?> getSKUByCode(String code) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'skus',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isNotEmpty) {
      return SKU.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSKU(SKU sku) async {
    final db = await database;
    return db.update(
      'skus',
      sku.toMap(),
      where: 'code = ?',
      whereArgs: [sku.code],
    );
  }

  // Branch Operations
  Future<int> insertBranch(InventoryBranch branch) async {
    final db = await database;
    return db.insert('branches', branch.toMap());
  }

  Future<List<InventoryBranch>> getAllBranches() async {
    final db = await database;
    final maps = await db.query('branches');
    return List.generate(maps.length, (i) => InventoryBranch.fromMap(maps[i]));
  }

  Future<int> deleteBranch(String id) async {
    final db = await database;
    return db.delete('branches', where: 'id = ?', whereArgs: [id]);
  }

  // In DatabaseHelper class
  Future<int> updateBranch(InventoryBranch branch) async {
    final db = await database;

    return await db.update(
      'branches',
      branch.toMap(),
      where: 'id = ?',
      whereArgs: [branch.id],
    );
  }

  Future<InventoryBranch> getBranch(String id) async {
    final db = await database;

    final maps = await db.query('branches', where: 'id = ?', whereArgs: [id]);
    return InventoryBranch.fromMap(maps.first);
  }
}
