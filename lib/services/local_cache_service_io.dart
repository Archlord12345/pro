import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import '../models/service.dart';
import 'database_helper.dart';
import 'local_cache_service.dart';

class SqfliteLocalCacheService implements LocalCacheService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<void> syncServices(List<Service> services) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('services');
      for (final service in services) {
        await txn.insert(
          'services',
          service.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> syncProducts(List<Product> products) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('products');
      for (final product in products) {
        await txn.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}

LocalCacheService createLocalCacheServiceImpl() => SqfliteLocalCacheService();
