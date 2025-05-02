import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/quick_alert.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/Products/payment_page.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Api/comment_service.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/core/widgets/rating_semmary.dart';
import 'package:quickalert/models/quickalert_type.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  static const String routeName = 'product_page'; // route Name pf this page:

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var productcomment;
  TextEditingController input = TextEditingController();
  TextEditingController output = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productcomment =
        ModalRoute.of(context)!.settings.arguments as ProductResponse;
  }

  void addComment() async {
    if (input.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty!")),
      );
      return;
    }

    String message =
        await CommentService.postComment(productcomment.productId, input.text);

    if (message == "Comment added successfully!") {
      setState(() {
        output.text = input.text;
        input.clear();
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments
        as ProductResponse; // receive data:
    final currentRating = arguments.numberOfRatings.toInt(); // لو كانت Double

    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        //shadowColor: Constant.whiteColor,
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage:
                  AssetImage('assets/images/image-13.png'), // ضع الصورة هنا
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
                padding: EdgeInsets.all(18),
                child: Text(
                  arguments.name,
                  style: TextStyle(
                      fontSize: 24,
                      color: Constant.whiteColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  arguments.productImage,
                  fit: BoxFit.cover,
                  width: 350,
                ),
              ),
            ),
            SizedBox(
              height: 75,
              //width: 70,
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
                        arguments.productImage, // استبدلها بالصور الفعلية
                        fit: BoxFit.cover,
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
                      /*const CircleAvatar(backgroundColor: Colors.grey, radius: 30,
                      backgroundImage: AssetImage('assets/images/owner.png'),
                      ),*/
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          //color: Colors.grey, // لون الخلفية في حال لم يتم تحميل الصورة
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/owner.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(arguments.authorName,
                          style: const TextStyle(
                              color: Constant.blackColorDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
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
                    arguments.name,
                    style: const TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    arguments.priceBeforeDiscount.toString(),
                    style: const TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    arguments.description,
                    style: const TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
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
                      onPressed: () {}),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          // نجوم التقييم حسب القيمة المختارة
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
                    'Available quantity: ${arguments.stock}', // text:
                    style: const TextStyle(
                      color: Constant.greyColor4,
                      fontSize: 15,
                      //fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(
                        color: Constant.greyColor4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        size: 30,
                        color: Constant.mainColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                        color: Constant.mainColor, fontSize: 25),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(
                        color: Constant.greyColor4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity < arguments.stock) {
                            quantity++;
                          }
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
            ),
            /* Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        addToCart(arguments.productId, quantity).then((value) {
                          if (value) {
                            quickAlert(
                                context: context,
                                title: "Added to cart successfully",
                                type: QuickAlertType.success);
                          } else {
                            quickAlert(
                                context: context,
                                title: "Error adding to cart",
                                type: QuickAlertType.error);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(
                              color: Constant.greyColor2,
                              width: 1), // لون وسمك الحدود
                          backgroundColor: Constant.whiteColor,
                          minimumSize: const Size(1, 60)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Constant.mainColor,
                            size: 24,
                          ),
                           SizedBox(width: 8),
                           Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Constant.black2Color, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            const SizedBox(height: 15),
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

                  // Rating Summary
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - overall rating
                      Column(
                        children: [
                          Text(
                            arguments.numberOfReviews.toString(),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Constant.black2Color,
                            ),
                          ),
                          Text(
                            'Based on ${arguments.numberOfRatings} Ratings',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),

                      // Right side - rating bars
                      Expanded(
                        child: Column(
                          children: [
                            // Calculate total ratings first
                            Builder(
                              builder: (context) {
                                final totalRatings = (arguments
                                            .ratingBreakdown['5 star'] ??
                                        0) +
                                    (arguments.ratingBreakdown['4 star'] ?? 0) +
                                    (arguments.ratingBreakdown['3 star'] ?? 0) +
                                    (arguments.ratingBreakdown['2 star'] ?? 0) +
                                    (arguments.ratingBreakdown['1 star'] ?? 0);

                                return Column(
                                  children: [
                                    _buildRatingBar(
                                        5,
                                        totalRatings > 0
                                            ? (arguments.ratingBreakdown[
                                                        '5 star'] ??
                                                    0) /
                                                totalRatings
                                            : 0,
                                        Colors.green),
                                    _buildRatingBar(
                                        4,
                                        totalRatings > 0
                                            ? (arguments.ratingBreakdown[
                                                        '4 star'] ??
                                                    0) /
                                                totalRatings
                                            : 0,
                                        Colors.lightGreen),
                                    _buildRatingBar(
                                        3,
                                        totalRatings > 0
                                            ? (arguments.ratingBreakdown[
                                                        '3 star'] ??
                                                    0) /
                                                totalRatings
                                            : 0,
                                        Colors.amber),
                                    _buildRatingBar(
                                        2,
                                        totalRatings > 0
                                            ? (arguments.ratingBreakdown[
                                                        '2 star'] ??
                                                    0) /
                                                totalRatings
                                            : 0,
                                        Colors.orange),
                                    _buildRatingBar(
                                        1,
                                        totalRatings > 0
                                            ? (arguments.ratingBreakdown[
                                                        '1 star'] ??
                                                    0) /
                                                totalRatings
                                            : 0,
                                        Colors.deepOrange),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'There are ${arguments.numberOfReviews} reviews in this product',
                      style: TextStyle(
                        fontSize: 14,
                        color: Constant.greyColor4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(),

                  // Reviews List
                  _buildReviewItem(),
                  const Divider(),
                  _buildReviewItem(),
                  const Divider(),
                  _buildReviewItem(),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        addToCart(arguments.productId, quantity).then((value) {
                          if (value) {
                            quickAlert(
                                context: context,
                                title: "Added to cart successfully",
                                type: QuickAlertType.success);
                          } else {
                            quickAlert(
                                context: context,
                                title: "Error adding to cart",
                                type: QuickAlertType.error);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          /*  side: const BorderSide(
                              color: Constant.greyColor2, width: 1),*/
                          backgroundColor: Constant.mainColor,
                          minimumSize: const Size(1, 60)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*Icon(
                            Icons.shopping_cart_outlined,
                            color: Constant.mainColor,
                            size: 24,
                          ),*/
                          SizedBox(width: 8),
                          Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Constant.whiteColor, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int rating, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text(
              '$rating',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    color: Colors.grey[200],
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      height: 8,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 26,
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                padding: EdgeInsets.all(4),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Constant.greyColor4),
                  shape: BoxShape.circle,
                  color: Constant.whiteColor,
                ),
                child: const Text(
                  'M',
                  style: TextStyle(
                    color: Constant.blackColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name
              const Text(
                'Mohamed Ahmed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Star rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          // Review text
          const Text(
            'Very Good Product and Fancy Very Good Product and Fancy',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          // Helpful button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: Constant.whiteColor,
              border: Border.all(color: Constant.greyColor4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Helpful',
              style: TextStyle(
                  fontSize: 13,
                  color: Constant.blackColorDark,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
