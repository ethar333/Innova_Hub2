
 // Deal Model:
class DealModel{

  String businessName;
  String description;
  String offerMoney;
  String offerDeal;
  int categoryId;
  List <String>? images;
 
 DealModel({required this.businessName,
 required this.description,
 required this.offerMoney,
 required this.offerDeal,
 required this.categoryId,
  this.images,
 });

  // to json:

  Map<String, dynamic> toJson(){
  
  return {
    'BusinessName' : businessName,
    'Description' : description,
    'OfferMoney' : offerMoney,
    'OfferDeal' : offerDeal,
    'CategoryId' : categoryId,
    'Pictures' : images ?? [],

  };

  }


}

