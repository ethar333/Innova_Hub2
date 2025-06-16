
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerInvestment {
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

  OwnerInvestment({
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

  factory OwnerInvestment.fromJson(Map<String, dynamic> json) {
  return OwnerInvestment(
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

class ApiService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';

  Future<List<OwnerInvestment>> getOwnerInvestments() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Deals/owner-deals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('🟢 Investments response: ${response.body}');  

      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => OwnerInvestment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load investments: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching investments: $e');
  }
}




  Future<UserProfile> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/User/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return UserProfile.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }
}









/*class ApiService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';

  Future<List<Investment>> getOwnerInvestments() async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Deal/owner-deals'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Investment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load investments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching investments: $e');
    }
  }
}*/