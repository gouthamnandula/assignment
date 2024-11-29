import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1/products';

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Check if the body is not empty and is valid JSON
        if (response.body.isNotEmpty) {
          final List<dynamic> data = jsonDecode(response.body);
          return data;
        } else {
          throw Exception('Empty response from server');
        }
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}