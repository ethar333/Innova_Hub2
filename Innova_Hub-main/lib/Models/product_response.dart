// Model:(products):

class CategoryModel {
  // attributes:
  String categoryName;
  String categoryDescription;
  List<ProductResponse> allProducts;

  // constructor:
  CategoryModel(
      {required this.categoryName,
      required this.categoryDescription,
      required this.allProducts});

  // from json:
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['CategoryName'],
      categoryDescription: json['CategoryDescription'],
      allProducts: json['AllProductsOnspecificCategories'] != null
          ? List<ProductResponse>.from(json["AllProductsOnspecificCategories"]
              .map((x) => ProductResponse.fromJson(x)))
          : [],
    );
  }

  // to json:
  Map<String, dynamic> toJson() {
    return {
      'CategoryName': categoryName,
      'CategoryDescription': categoryDescription,
      'AllProductsOnspecificCategories':
          allProducts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CategoryModel{categoryName: $categoryName, categoryDescription: $categoryDescription, allProducts: $allProducts}';
  }
}

class ProductResponse {
  // Basic product info
  final int productId;
  final String name;
  final String description;
  final String authorId;
  final String authorName;

  // Category info
  final int categoryId;
  final String categoryName;

  // Product details
  final String weight;
  final String dimensions;
  final String productImage;
  final List<String> productImages;

  // Pricing
  final num priceBeforeDiscount;
  final num priceAfterDiscount;
  final num discountPercentage;

  // Inventory
  final int stock;
  final bool isAvailable;

  // Ratings & Reviews
  final num averageRating;
  final int numberOfRatings;
  final Map<String, int> ratingBreakdown;
  final int numberOfReviews;
  final List<dynamic> productReviews;

  // Variants
  final List<String> productSizes;
  final List<String> productColors;

  ProductResponse({
    required this.productId,
    required this.name,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.categoryId,
    required this.categoryName,
    required this.weight,
    required this.dimensions,
    required this.productImage,
    required this.productImages,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.discountPercentage,
    required this.stock,
    required this.isAvailable,
    required this.averageRating,
    required this.numberOfRatings,
    required this.ratingBreakdown,
    required this.numberOfReviews,
    required this.productReviews,
    required this.productSizes,
    required this.productColors,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productId: json['ProductId'] as int? ?? 0,
      name: json['ProductName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      authorId: json['AuthorId'] as String? ?? '',
      authorName: json['AuthorName'] as String? ?? '',
      categoryId: json['CategoryId'] as int? ?? 0,
      categoryName: json['CategoryName'] as String? ?? '',
      weight: json['Weight']?.toString() ?? '',
      dimensions: json['Dimensions'] as String? ?? '',
      productImage: json['HomePicture'] as String? ?? '',
      productImages: (json['Pictures'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      priceBeforeDiscount: (json['PriceBeforeDiscount'] as num?) ?? 0,
      priceAfterDiscount: (json['PriceAfterDiscount'] as num?) ?? 0,
      discountPercentage: (json['DiscountPercentage'] as num?) ?? 0,
      stock: json['Stock'] as int? ?? 0,
      isAvailable: (json['Stock'] as int? ?? 0) > 0,
      averageRating: (json['AverageRating'] as num?) ?? 0,
      numberOfRatings: json['NumberOfRatings'] as int? ?? 0,
      ratingBreakdown: (json['RatingBreakdown'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          {
            '1 star': 0,
            '2 star': 0,
            '3 star': 0,
            '4 star': 0,
            '5 star': 0,
          },
      numberOfReviews: json['NumberOfReviews'] as int? ?? 0,
      productReviews: json['ProductReviews'] as List<dynamic>? ?? [],
      productSizes: (json['ProductSizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      productColors: (json['ProductColors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'ProductName': name,
      'Description': description,
      'AuthorId': authorId,
      'AuthorName': authorName,
      'CategoryId': categoryId,
      'CategoryName': categoryName,
      'Weight': weight,
      'Dimensions': dimensions,
      'HomePicture': productImage,
      'Pictures': productImages,
      'PriceBeforeDiscount': priceBeforeDiscount,
      'PriceAfterDiscount': priceAfterDiscount,
      'DiscountPercentage': discountPercentage,
      'Stock': stock,
      'IsAvailable': isAvailable,
      'AverageRating': averageRating,
      'NumberOfRatings': numberOfRatings,
      'RatingBreakdown': ratingBreakdown,
      'NumberOfReviews': numberOfReviews,
      'ProductReviews': productReviews,
      'ProductSizes': productSizes,
      'ProductColors': productColors,
    };
  }
}
/*class ProductResponse{
  
  // attributes of each product:
  String name;
  String description;
  String authorName;
  String productImage;
  List<String> productImages; 
  num price;  
  bool isAvailable;
  int stock;
  int productId;

   // constructor:
   ProductResponse({required this.name,
   required this.description,
   required this.authorName,
   required this.productImage,
   required this.productImages,
   required this.price,
   required this.isAvailable,
   required this.stock,
   required this.productId
   });

  // factory constructor:(from json):
  factory ProductResponse.fromJson(Map<String, dynamic> json){

    return ProductResponse(
      name: json['ProductName'],
      description: json['ProductDescription'],
      authorName: json['AuthorName'],
      productImage: json['HomePicture'],
      productImages: List<String>.from(json['ProductPictures']),
      price: json['ProductPrice'].toDouble(),
      isAvailable: json['IsAvailable'],
      stock: json['Stock'],
      productId: json['ProductId'],
    );
  }
 
 // to json:
   Map<String, dynamic> toJson(){

     return{
      'ProductName' : name,
      'ProductDescription' : description,
      'AuthorName' : authorName,
      'HomePicture' : productImage,
      'ProductPictures' : productImages,
      'ProductPrice' : price,
      'IsAvailable' : isAvailable,
      'Stock' : stock,
      'ProductId': productId,

      };
   }

}
*/
