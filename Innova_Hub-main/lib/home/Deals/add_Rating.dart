import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class RatingModel {
  final int productId;
  final int ratingValue;

  RatingModel({
    required this.productId,
    required this.ratingValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'RatingValue': ratingValue,
    };
  }
}

Future<void> sendProductRating(RatingModel rating) async {
  try {
    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User is not logged in. Token is missing.');
    }

    final response = await http.post(
      Uri.parse("https://innova-hub.premiumasp.net/api/Product/addRating"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Rating submitted successfully");
    } else {
      var errorData = jsonDecode(response.body);
      print("Failed to submit rating: ${errorData['message']}");
      // Emit error state if needed
    }
  } catch (e) {
    print("Error submitting rating: $e");
    // Emit error state if needed
  }
}
