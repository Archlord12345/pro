import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/product.dart';
import '../services/data_repository.dart';

class AppProvider with ChangeNotifier {
  final DataRepository _repository = DataRepository();

  List<Service> _services = [];
  List<Product> _products = [];
  bool _isLoading = false;

  List<Service> get services => _services;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _repository.getServices();
      _products = await _repository.getProducts();
    } catch (e) {
      debugPrint('Error fetching data: $e');
      // On initial error, we could populate with mock data if local DB is empty
      if (_services.isEmpty) _services = proServices;
      if (_products.isEmpty) _products = proProducts;
    }

    _isLoading = false;
    notifyListeners();
  }
}
