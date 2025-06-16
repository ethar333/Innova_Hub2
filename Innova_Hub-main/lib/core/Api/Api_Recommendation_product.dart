
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/products/Recommended_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationService {
  Future<List<RecommendedProduct>> fetchRecommendedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('https://innova-hub.premiumasp.net/api/recommendations/popular?count=5'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['Recommendations'];
      return products.map((e) => RecommendedProduct.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recommended products');
    }
  }
}
