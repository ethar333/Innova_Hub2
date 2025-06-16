
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvestorInvestment {
  final String dealId;
  final String projectName;
  final String? investorName;
  final String ownerName;
  final double offerMoney;
  final double offerDeal;
  final String status;
  final String createdAt;
  final double totalProfit;
  final String? lastDistribution;
  final int durationInMonths;
  final String startDate;
  final String endDate;
  final int? remainingDays;

  InvestorInvestment({
    required this.dealId,
    required this.projectName,
    this.investorName,
    required this.ownerName,
    required this.offerMoney,
    required this.offerDeal,
    required this.status,
    required this.createdAt,
    required this.totalProfit,
    this.lastDistribution,
    required this.durationInMonths,
    required this.startDate,
    required this.endDate,
    this.remainingDays,
  });

  factory InvestorInvestment.fromJson(Map<String, dynamic> json) {
  return InvestorInvestment(
    dealId: json['DealId'].toString(),
    projectName: json['ProjectName'],
    investorName: json['InvestorName'],
    ownerName: json['OwnerName'],
    offerDeal: (json['OfferDeal'] ?? 0).toDouble(),
    offerMoney: (json['OfferMoney'] ?? 0).toDouble(),
    status: json['Status'] ?? '',
    createdAt: json['CreatedAt'],
    totalProfit: (json['TotalProfit'] ?? 0).toDouble(),
    lastDistribution: json['LastDistribution'],
    durationInMonths: json['DurationInMonths'] ?? 0,
    startDate: json['StartDate'],
    endDate: json['EndDate'],
    remainingDays: json['RemainingDays'],
  );
}

}

Future<List<InvestorInvestment>> fetchInvestorInvestments() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final url =
      Uri.parse('https://innova-hub.premiumasp.net/api/Deals/investor-deals');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => InvestorInvestment.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load investments');
  }
}
 

 class ApiService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';

  Future<List<InvestorInvestment>> getInvestorInvestments() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Deals/investor-deals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('🟢 Investments response: ${response.body}');  

      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => InvestorInvestment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load investments: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching investments: $e');
  }
}
 }






/*Future<List<InvestorInvestment>> fetchInvestorInvestments() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final url = Uri.parse(
      'https://innova-hub.premiumasp.net/api/Investment/investor-investments');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => InvestorInvestment.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load investments');
  }
}*/

