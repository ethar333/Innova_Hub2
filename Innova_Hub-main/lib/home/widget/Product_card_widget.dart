
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String author;
  final double rating;
  final double price;
  final int stock;
  final String dateAdded;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.author,
    required this.rating,
    required this.price,
    required this.stock,
    required this.dateAdded,
  }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  height: 170,
                  width: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F7FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Constant.mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Constant.blackColorDark
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Row(
              children: [
                const Text('By ', style: TextStyle(fontSize: 14)),
                Text(
                  author,
                  style: const TextStyle(
                    color: Constant.mainColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Row(
              children: [
                ...List.generate(4, (index) => const Icon(Icons.star, color: Color(0xFFFFC107), size: 20)),
                const Icon(Icons.star_half, color: Color(0xFFFFC107), size: 20),
                const SizedBox(width: 4),
                Text('(${rating.toStringAsFixed(1)})', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                   '24${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Constant.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7EC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Stock: $stock',
                    style: const TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Text(
              'From your favorite category #2 · Similar to products in your wishlist · Within your preferred',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 2, bottom: 8),
            child: Text(
              'Added: $dateAdded',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.end,
            ),
            
          ),
        ],
      ),
    );
  }
}