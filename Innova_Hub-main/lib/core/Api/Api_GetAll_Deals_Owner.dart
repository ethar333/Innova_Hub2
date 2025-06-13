// services/api_manager_deals.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/Deals/Deal_Business_Owner_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManagerDealsOwner {
  static Future<List<DealBusinessOwner>> getAllDealsForOwner() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) throw Exception("Token not found");

    final url = Uri.parse(
        "https://innova-hub.premiumasp.net/api/Deals/GetAllDealsForSpecificBusinessOwner");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final ownerResponse = OwnerDealsResponse.fromJson(jsonData);
      return ownerResponse.deals;
    } else {
      throw Exception("Failed to load deals: ${response.statusCode}");
    }
  }

  // Function to terminate deal:
  static Future<void> terminateDeal(
      int dealId, String reason, String notes, BuildContext context) async {
    print("Sending termination request...");
    print("Deal ID: $dealId");
    print("Reason: $reason");
    print("Notes: $notes");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("Token not found in SharedPreferences.");
      return;
    }

    print("🔐 Token: $token");

    final url = Uri.parse(
        "https://innova-hub.premiumasp.net/api/Deals/request-termination");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "DealId": dealId,
        "EndReason": reason,
        "TerminationNotes": notes,
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deal terminated successfully")),
      );
    } else {
      final json = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json["Message"] ?? "Failed to terminate deal")),
      );
    }
  }
}

