/*import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/addcomment.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:innovahub_app/home/widget/listorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myorder extends StatefulWidget {
  static const String routeName = 'myorder';
  @override
  State<myorder> createState() => _myorderState();
}

class _myorderState extends State<myorder> {
  // routeName of this screen:
  TextEditingController _commentController = TextEditingController();

  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Review",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            MyWidget(
             
            ),
            _isSubmitted
                ? SizedBox.shrink()
                : Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Constant.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Constant.greyColor4),
                            ),
                            child: TextField(
                              controller: _commentController,
                              maxLines: null,
                              decoration: const InputDecoration.collapsed(
                                hintText: "What Should Other Customers Know?",
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final commentText = _commentController.text.trim();

                  if (commentText.isNotEmpty) {
                    final comment = CommentModel(
                      productId:17 ,
                      comment: commentText,
                    );

                    await sendProductComment(comment);

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('lastComment', commentText);

                    _commentController.clear();
                  } else {
                    print("Comment is empty");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(220, 50),
                ),
                child: const Text('Submit',
                    style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {

  static const String routeName = 'ReviewScreen';

  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Map<String, dynamic>> reviews = [];
  Map<int, int> ratings = {};
  Map<int, TextEditingController> commentControllers = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousReviews();
  }

  Future<void> _loadPreviousReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReviews = prefs.getString('savedReviews');
    if (savedReviews != null) {
      setState(() {
        reviews = List<Map<String, dynamic>>.from(jsonDecode(savedReviews));
      });
    }
  }

  @override
  void dispose() {
    for (var controller in commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitReview(int productId) async {
    final ratingValue = ratings[productId] ?? 0;
    final commentText = commentControllers[productId]?.text.trim() ?? '';

    if (ratingValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a comment')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await rateProduct(
        productId: productId,
        ratingValue: ratingValue,
        comment: commentText,
      );

      // Add the new review to the list
      final newReview = {
        'productId': productId,
        'userName': 'You',
        'rating': ratingValue,
        'comment': commentText,
        'date': DateTime.now().toIso8601String(),
      };

      setState(() {
        reviews.insert(0, newReview);
        ratings[productId] = 0;
        commentControllers[productId]?.clear();
      });

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedReviews', jsonEncode(reviews));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product Reviews"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing reviews section

            // Review input section for each product in cart
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartController.cartItems[index];
                final productId = item["ProductId"];
                final currentRating = ratings[productId] ?? 0;

                commentControllers.putIfAbsent(
                    productId, () => TextEditingController());

                return _buildProductReviewCard(item, productId, currentRating);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductReviewCard(
      Map<String, dynamic> item, int productId, int currentRating) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item["HomePictureUrl"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              starIndex < currentRating
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: starIndex < currentRating
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                ratings[productId] = starIndex + 1;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: commentControllers[productId],
              decoration: InputDecoration(
                hintText: "Share your experience with this product...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _submitReview(productId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> rateProduct({
  required int productId,
  required int ratingValue,
  required String comment,
}) async {
  // Validate rating value
  if (ratingValue < 1 || ratingValue > 5) {
    throw Exception('Rating value must be between 1 and 5');
  }

  // Get token from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('User not authenticated');
  }

  final response = await http.post(
    Uri.parse('https://innova-hub.premiumasp.net/api/Product/rateAndComment'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'ProductId': productId,
      'RatingValue': ratingValue,
      'Comment': comment,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Failed to submit rating');
  }
}




