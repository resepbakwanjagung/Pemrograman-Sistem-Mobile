import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Service untuk HTTP Networking & Konsumsi Fake Store API (Pertemuan 7)
class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com';

  /// Mengambil seluruh data produk dari endpoint GET /products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products'))
          .timeout(const Duration(seconds: 10));

      print('[ProductService] GET /products status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server mengembalikan status: ${response.statusCode}');
      }
    } catch (e) {
      print('[ProductService] Error fetchProducts: $e');
      rethrow;
    }
  }

  /// Mengambil detail satu produk dari endpoint GET /products/{id}
  Future<Product> fetchProductDetail(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/$id'))
          .timeout(const Duration(seconds: 10));

      print('[ProductService] GET /products/$id status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail produk (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('[ProductService] Error fetchProductDetail: $e');
      rethrow;
    }
  }
}