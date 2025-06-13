
class OwnerDealsResponse {
  final String businessOwnerId;
  final String businessOwnerName;
  final List<DealBusinessOwner> deals;

  OwnerDealsResponse({
    required this.businessOwnerId,
    required this.businessOwnerName,
    required this.deals,
  });

  factory OwnerDealsResponse.fromJson(Map<String, dynamic> json) {
    return OwnerDealsResponse(
      businessOwnerId: json['BusinessOwnerId'],
      businessOwnerName: json['BusinessOwnerName'],
      deals: (json['Deals'] as List)
          .map((dealJson) => DealBusinessOwner.fromJson(dealJson))
          .toList(),
    );
  }
}

class DealBusinessOwner {
  final int dealId;
  final String businessName;
  final String description;
  final double offerMoney;
  final double offerDeal;
  final List<String> pictures;
  final int categoryId;
  final String categoryName;
  final double manufacturingCost;
  final double estimatedPrice;
  final bool isApproved;

  DealBusinessOwner({
    required this.dealId,
    required this.businessName,
    required this.description,
    required this.offerMoney,
    required this.offerDeal,
    required this.pictures,
    required this.categoryId,
    required this.categoryName,
    required this.manufacturingCost,
    required this.estimatedPrice,
    required this.isApproved,
  });

  factory DealBusinessOwner.fromJson(Map<String, dynamic> json) {
    return DealBusinessOwner(
      dealId: json['DealId'],
      businessName: json['BusinessName'],
      description: json['Description'],
      offerMoney: (json['OfferMoney'] as num).toDouble(),
      offerDeal: (json['OfferDeal'] as num).toDouble(),
      pictures: List<String>.from(json['Pictures']),
      categoryId: json['CategoryId'],
      categoryName: json['CategoryName'],
      manufacturingCost: (json['ManufacturingCost'] as num).toDouble(),
      estimatedPrice: (json['EstimatedPrice'] as num).toDouble(),
      isApproved: json['IsApproved'],
    );
  }
}
