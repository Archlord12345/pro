import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../models/service.dart';
import '../models/product.dart';
import 'database_helper.dart';

class DataRepository {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  // --- Services ---

  Future<List<Service>> getServices() async {
    try {
      // Try to fetch from Supabase
      final response = await _supabase.from('services').select();
      final services = response.map((data) => Service.fromSupabase(data)).toList();

      // Sync with local DB
      await _syncServicesLocal(services);
      return services;
    } catch (e) {
      // If offline or error, fetch from local SQLite
      return await _getServicesLocal();
    }
  }

  Future<void> _syncServicesLocal(List<Service> services) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('services');
      for (var service in services) {
        await txn.insert('services', service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Service>> _getServicesLocal() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('services');
    return maps.map((map) => Service.fromMap(map)).toList();
  }

  // --- Products ---

  Future<List<Product>> getProducts() async {
    try {
      final response = await _supabase.from('products').select();
      final products = response.map((data) => Product.fromSupabase(data)).toList();

      await _syncProductsLocal(products);
      return products;
    } catch (e) {
      return await _getProductsLocal();
    }
  }

  Future<void> _syncProductsLocal(List<Product> products) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('products');
      for (var product in products) {
        await txn.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Product>> _getProductsLocal() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }
}
