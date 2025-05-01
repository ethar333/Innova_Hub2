import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentModel {
  final int productId;
  final String comment;

  CommentModel({
    required this.productId,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Comment': comment,
    };
  }
}

Future<void> sendProductComment(CommentModel comment) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not logged in. Token missing.');
    }

    final response = await http.post(
      Uri.parse("https://innova-hub.premiumasp.net/api/Product/AddComment"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(comment.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Comment submitted successfully");
      // Emit success state if needed
    } else {
      var errorData = jsonDecode(response.body);
      print("Failed to submit comment: ${errorData['message']}");
      // Emit error state if needed
    }
  } catch (e) {
    print("Error submitting comment: $e");
    // Emit error state if needed
  }
}
