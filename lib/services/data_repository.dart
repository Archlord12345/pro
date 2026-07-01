import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../models/service.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/cyber_session.dart';
import 'database_helper.dart';

class DataRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _dbHelper = DatabaseHelper.instance;

  // --- Services ---

  Future<List<Service>> getServices() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('services').get();
      final services = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Service.fromMap(data);
      }).toList();

      await _syncServicesLocal(services);
      return services;
    } catch (e) {
      debugPrint('Error getting services: $e');
      return [];
    }
  }

  Future<void> _syncServicesLocal(List<Service> services) async {
    if (kIsWeb) return; // Skip local sync on web
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('services');
      for (var service in services) {
        await txn.insert('services', service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> addService(Service service) async {
    try {
      await _firestore.collection('services').doc(service.id).set(service.toMap());
    } catch (e) {
      debugPrint('Error adding service: $e');
    }
  }

  Future<void> updateService(Service service) async {
    try {
      await _firestore.collection('services').doc(service.id).update(service.toMap());
    } catch (e) {
      debugPrint('Error updating service: $e');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _firestore.collection('services').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting service: $e');
    }
  }

  // --- Products ---

  Future<List<Product>> getProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();

      await _syncProductsLocal(products);
      return products;
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  Future<void> _syncProductsLocal(List<Product> products) async {
    if (kIsWeb) return; // Skip local sync on web
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('products');
      for (var product in products) {
        await txn.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).set(product.toMap());
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).update(product.toMap());
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting product: $e');
    }
  }

  // --- Reviews ---

  Future<List<Review>> getReviews() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('reviews').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Review.fromMap(data);
      }).toList();
    } catch (e) {
      debugPrint('Error getting reviews: $e');
      return [];
    }
  }

  Future<List<Review>> getReviewsForProduct(String productId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('reviews')
          .where('product_id', isEqualTo: productId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Review.fromMap(data);
      }).toList();
    } catch (e) {
      debugPrint('Error getting reviews for product: $e');
      return [];
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').doc(review.id).set(review.toMap());
    } catch (e) {
      debugPrint('Error adding review: $e');
    }
  }

  Future<void> deleteReview(String id) async {
    try {
      await _firestore.collection('reviews').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting review: $e');
    }
  }

  // --- Cyber Tickets ---

  Future<List<CyberTicket>> getCyberTickets() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('cyber_tickets').get();
      final tickets = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CyberTicket.fromMap(data);
      }).toList();
      return tickets;
    } catch (e) {
      debugPrint('Error getting cyber tickets: $e');
      return [];
    }
  }

  Future<void> addCyberTicket(CyberTicket ticket) async {
    try {
      await _firestore.collection('cyber_tickets').doc(ticket.id).set(ticket.toMap());
    } catch (e) {
      debugPrint('Error adding ticket: $e');
    }
  }

  Future<void> updateCyberTicket(CyberTicket ticket) async {
    try {
      await _firestore.collection('cyber_tickets').doc(ticket.id).update(ticket.toMap());
    } catch (e) {
      debugPrint('Error updating ticket: $e');
    }
  }

  Future<void> deleteCyberTicket(String id) async {
    try {
      await _firestore.collection('cyber_tickets').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting ticket: $e');
    }
  }

  // --- Computers ---

  Future<List<Computer>> getComputers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('computers').get();
      final computers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Computer.fromMap(data);
      }).toList();
      return computers;
    } catch (e) {
      debugPrint('Error getting computers: $e');
      return [];
    }
  }

  Future<void> updateComputer(Computer computer) async {
    try {
      await _firestore.collection('computers').doc(computer.id).update(computer.toMap());
    } catch (e) {
      debugPrint('Error updating computer: $e');
    }
  }
}
