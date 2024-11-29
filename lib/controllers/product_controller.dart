import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../data_layer/product_service.dart';
import '../models/product_model.dart';

class ProductController with ChangeNotifier {
  final ProductService _service = ProductService();
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.fetchProducts().timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timeout. Please check your internet.');
        },
      );

      // Filter out products with invalid or empty image URLs
      _products = data
          .map((e) => ProductModel.fromJson(e))
          .where((product) => product.images.isNotEmpty)
          .toList();

      if (_products.isEmpty) {
        _errorMessage = 'No valid products found';
      }
    } on SocketException {
      _errorMessage = 'No internet connection';
    } on TimeoutException {
      _errorMessage = 'Connection timed out. Please try again.';
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}