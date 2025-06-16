

class RecommendedProduct {
  final int id;
  final String name;
  final String author;
  final double price;
  final double rating;
  final int stock;
  final String imageUrl;
  final String category;
  final String createdAt;

  RecommendedProduct({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    required this.rating,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) {
    return RecommendedProduct(
      id: json['ProductId'],
      name: json['ProductName'],
      author: json['AuthorName'],
      price: json['DiscountedPrice'] ?? json['Price'],
      rating: (json['AverageRating'] as num).toDouble(),
      stock: json['Stock'],
      imageUrl: json['HomePictureUrl'],
      category: json['Category'],
      createdAt: json['CreatedAt'],
    );
  }
}
