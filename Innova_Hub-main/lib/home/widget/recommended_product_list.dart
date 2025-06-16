

import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/products/Recommended_product_model.dart';
import 'package:innovahub_app/core/Api/Api_Recommendation_product.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/widget/Product_card_widget.dart';

class RecommendedProductsList extends StatelessWidget {
  final RecommendationService service = RecommendationService();

  RecommendedProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecommendedProduct>>(
      future: service.fetchRecommendedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recommendations available.'));
        }

        final products = snapshot.data!;

        return SizedBox(
          height: 455,    // heigth of card: 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                imageUrl: product.imageUrl,
                category: product.category,
                title: product.name,
                author: product.author,
                rating: product.rating,
                price: product.price,
                stock: product.stock,
                dateAdded: product.createdAt,
              );
            },
          ),
        );
      },
    );
  }
}
