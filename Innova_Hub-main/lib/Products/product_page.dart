
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Api/Api_return_comment.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Api/comment_service.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static const String routeName = 'product_page';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductResponse product;
  TextEditingController commentController = TextEditingController();
  int quantity = 1;
  List<ProductComment> comments = [];
  bool isLoadingComments = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as ProductResponse;
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      isLoadingComments = true;
    });
    try {
      final response = await fetchProductComments(product.productId);
      if (response != null) {
        setState(() {
          comments = response.comments;
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoadingComments = false;
      });
    }
  }

  Future<void> addComment() async {
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty!")),
      );
      return;
    }

    final message = await CommentService.postComment(
        product.productId, commentController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (message == "Comment added successfully!") {
      commentController.clear();
      await _loadComments(); // Refresh comments after adding new one
    }
  }

  Future<void> addToCart() async {
    final cartService = CartService(); // Create instance of CartService

    try {
      final success = await cartService.addToCart(product.productId, quantity);

      if (success) {
        // Show success message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Product added to cart',
        );
      } else {
        // Show error message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to add product to cart',
        );
      }
    } catch (e) {
      // Show network error message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Network Error',
        text: 'Please check your internet connection',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final currentRating = product.numberOfRatings.toInt();

    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
            color: Constant.blackColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/image-13.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Constant.mainColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              width: double.infinity,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Constant.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product.productImage,
                  fit: BoxFit.cover,
                  width: 350,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 100),
                ),
              ),
            ),
            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        product.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error_outline, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/owner.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product.authorName,
                        style: const TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Constant.mainColor,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.priceBeforeDiscount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Constant.blackColorDark,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < currentRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: index < currentRating
                                    ? Colors.amber
                                    : Constant.greyColor,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "$currentRating Review(s)",
                            style: TextStyle(color: Constant.greyColor4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available quantity: ${product.stock}',
                    style: const TextStyle(
                      color: Constant.greyColor4,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      color: Constant.mainColor,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(color: Constant.greyColor4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity < product.stock) quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),const SizedBox(height: 15),
            const Divider(
              color: Constant.greyColor2,
              indent: 18,
              endIndent: 18,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Ratings & Reviews',
                    style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRatingSummary(),
                  const SizedBox(height: 16),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'There are ${product.numberOfReviews} reviews for this product',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Constant.greyColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),
                  if (isLoadingComments)
                    const Center(child: CircularProgressIndicator())
                  else if (comments.isEmpty)
                    const Center(child: Text("No comments yet"))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          _buildReviewItem(comments[index]),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: addToCart,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Constant.mainColor,
                        minimumSize: const Size(1, 60),
                      ),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                          color: Constant.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  Widget _buildRatingSummary() {
    final totalRatings = (product.ratingBreakdown['5 star'] ?? 0) +
        (product.ratingBreakdown['4 star'] ?? 0) +
        (product.ratingBreakdown['3 star'] ?? 0) +
        (product.ratingBreakdown['2 star'] ?? 0) +
        (product.ratingBreakdown['1 star'] ?? 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              product.numberOfReviews.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Constant.black2Color,
              ),
            ),
            Text(
              'Based on ${product.numberOfRatings} Ratings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(
                5,
                totalRatings > 0
                    ? (product.ratingBreakdown['5 star'] ?? 0) / totalRatings
                    : 0,
                Colors.green,
              ),
              _buildRatingBar(
                4,
                totalRatings > 0
                    ? (product.ratingBreakdown['4 star'] ?? 0) / totalRatings
                    : 0,
                Colors.lightGreen,
              ),
              _buildRatingBar(
                3,
                totalRatings > 0
                    ? (product.ratingBreakdown['3 star'] ?? 0) / totalRatings
                    : 0,
                Colors.amber,
              ),
              _buildRatingBar(
                2,
                totalRatings > 0
                    ? (product.ratingBreakdown['2 star'] ?? 0) / totalRatings
                    : 0,
                Colors.orange,
              ),
              _buildRatingBar(
                1,
                totalRatings > 0
                    ? (product.ratingBreakdown['1 star'] ?? 0) / totalRatings
                    : 0,
                Colors.deepOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildRatingBar(int stars, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$stars star'),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percentage * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ProductComment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Text(
                  comment.userName.isNotEmpty
                      ? comment.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ),
              const SizedBox(width: 12),
              Text(
                comment.userName.isNotEmpty ? comment.userName : 'Anonymous',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < product.numberOfRatings // Using product's rating
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            comment.commentText,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Helpful',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*String _formatTime(DateTime dateTime) {
  // Formats to something like "10:30 AM"
  return DateFormat('h:mm a').format(dateTime);
}*/
}

