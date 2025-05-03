
import 'package:http/http.dart' as http;

import 'dart:convert';

class ProductCommentsResponse {
  final String message;
  final List<ProductComment> comments;

  ProductCommentsResponse({
    required this.message,
    required this.comments,
  });

  factory ProductCommentsResponse.fromJson(Map<String, dynamic> json) {
    return ProductCommentsResponse(
      message: json['Message'],
      comments: (json['Comments'] as List)
          .map((item) => ProductComment.fromJson(item))
          .toList(),
    );
  }
}

class ProductComment {
  final int commentId;
  final String userId;
  final String userName;
  final String commentText;
  final DateTime createdAt;

  ProductComment({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.createdAt,
  });

  factory ProductComment.fromJson(Map<String, dynamic> json) {
    return ProductComment(
      commentId: json['CommentId'],
      userId: json['UserId'],
      userName: json['UserName'],
      commentText: json['CommentText'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}

Future<ProductCommentsResponse?> fetchProductComments(int productId) async {
  final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Product/GetAllProductComments/$productId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ProductCommentsResponse.fromJson(jsonData);
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }

  return null;
}