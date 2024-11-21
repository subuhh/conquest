import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EdamamService {
  final String appId = dotenv.get('EDAMAM_APP_ID');
  final String appKey = dotenv.get('EDAMAM_API_KEY');
  final String baseUrl = "https://api.edamam.com/api/food-database/v2";

  Future<Map<String, dynamic>> searchFood(String query) async {
    try {
      final url = Uri.parse(
          "$baseUrl/parser?app_id=$appId&app_key=$appKey&ingr=$query");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Failed to fetch food data: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error while searching food: $e");
    }
  }

  Future<Map<String, dynamic>> getNutrients(
      Map<String, dynamic> foodData) async {
    try {
      final url = Uri.parse("$baseUrl/nutrients?app_id=$appId&app_key=$appKey");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ingredients": [foodData]
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Failed to fetch nutrients data: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error while fetching nutrients: $e");
    }
  }
}
