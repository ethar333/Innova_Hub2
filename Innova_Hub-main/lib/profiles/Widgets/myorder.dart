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
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';

class CommentModel {
  final int productId;
  final int ratingValue;
  final String comment;

  CommentModel({
    required this.productId,
    required this.ratingValue,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'RatingValue': ratingValue,
      'Comment': comment,
    };
  }
}

Future<void> sendProductRating(CommentModel model) async {
  final url = "https://innova-hub.premiumasp.net/api/Product/rateAndComment";
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      print('Rating submitted successfully');
    } else {
      print('Failed to submit rating.');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');
    }
  } catch (e) {
    print('Error occurred while sending rating: $e');
  }
}

class MyWidget extends StatefulWidget {
  static const String routname = "MyWidget";
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Map<String, dynamic>> reviews = [];

  Map<int, int> ratings = {};
  Map<int, TextEditingController> commentControllers = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(" Reviews"),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = CartController.cartItems[index];
            final productId = item["ProductId"];
            final currentRating = ratings[productId] ?? 0;

            commentControllers.putIfAbsent(
                productId, () => TextEditingController());

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 90,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(item["HomePictureUrl"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "How did you find this product?",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return IconButton(
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentControllers[productId],
                    decoration: InputDecoration(
                      hintText: "What should others know?",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerRight,
                      child: // Add these at the top of your widget

                          ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                final ratingValue = ratings[productId] ?? 0;
                                final commentText =
                                    commentControllers[productId]
                                            ?.text
                                            .trim() ??
                                        '';

                                if (ratingValue == 0 || commentText.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please add a rating and a comment')),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await sendProductRating(
                                    CommentModel(
                                      productId: productId,
                                      ratingValue: ratingValue,
                                      comment: commentText,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Review submitted'),
                                      backgroundColor: Constant.mainColor,
                                    ),
                                  );

                                  // Add the new review to the list of reviews
                                  reviews.insert(0, {
                                    'userName':
                                        'You', // Example: can be the logged-in user
                                    'rating': ratingValue,
                                    'comment': commentText,
                                  });

                                  setState(() {
                                    ratings[productId] = 0;
                                    commentControllers[productId]?.clear();
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to submit review'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Submit',
                            style: TextStyle(color: Colors.white)),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
