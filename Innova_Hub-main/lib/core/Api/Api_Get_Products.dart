

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/product_response.dart';

class ApiManagerProducts {
  static Future<List<ProductResponse>> getAllProducts() async {
    final url = Uri.parse('https://innova-hub.premiumasp.net/api/Product/getAllProducts?page=1&pageSize=100');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List productsJson = jsonData['Products'];
      return productsJson.map((json) => ProductResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
