import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';

class ProductService {
  Future<List<Product>> getSaleProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/products/sale'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Không thể lấy danh sách sản phẩm giảm giá');
      }
    } catch (e) {
      print('>>> Error getting sale products: $e');
      return [];
    }
  }

  Future<List<Product>> getNewProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/products/new'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Không thể lấy danh sách sản phẩm mới');
      }
    } catch (e) {
      print('>>> Error getting new products: $e');
      return [];
    }
  }

  Future<List<Product>> getProductsByTag(String tagName) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/products/tag/$tagName'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Không thể lấy danh sách sản phẩm theo tag $tagName');
      }
    } catch (e) {
      print('>>> Error getting products by tag $tagName: $e');
      return [];
    }
  }
}
