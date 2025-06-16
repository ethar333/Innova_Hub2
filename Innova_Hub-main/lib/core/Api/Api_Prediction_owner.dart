import 'dart:convert';
import 'package:http/http.dart' as http;

class PredictionService {
  static Future<double?> predictSales({
    required double adBudget,
    required double unitPrice,
    required int unitsSold,
    required String productType,
    required String season,
    required String marketingChannel,
  }) async {
    final url = Uri.parse(
        'https://innova-hub.premiumasp.net/api/Recommendations/predict-sales');

    final body = {
      "adBudget": adBudget,
      "unitPrice": unitPrice,
      "unitsSold": unitsSold,
      "productType": productType,
      "season": season,
      "marketingChannel": marketingChannel,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['PredictedRevenue'];
    } else {
      print('Prediction API error (${response.statusCode}): ${response.body}');
      return null;
    }
  }
}
