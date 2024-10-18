import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FatSecretService {
  final String clientId = '913d595125a84eeeaee95366d3d8028d';
  final String clientSecret = '2c0f2dc14107411db9d7e2317d53af5b';
  final String tokenUrl = 'https://oauth.fatsecret.com/connect/token';
  final String apiBaseUrl = 'https://platform.fatsecret.com/rest/server.api';

  // Secure storage for storing the token
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Fetch OAuth 2.0 token
  Future<String?> getAccessToken() async {
    // Check if token is already stored
    String? accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      // Token doesn't exist, fetch a new one
      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> tokenData = jsonDecode(response.body);
        accessToken = tokenData['access_token'];

        // Store the token securely
        await storage.write(key: 'access_token', value: accessToken);
      } else {
        throw Exception('Failed to fetch access token');
      }
    }

    return accessToken;
  }

  // Generic function to make API requests
  Future<dynamic> fetchData(String method, Map<String, String> params) async {
    // Get access token
    String? accessToken = await getAccessToken();
    if (accessToken == null) throw Exception('Access token is null');

    params['method'] = method;
    params['format'] = 'json';

    // Prepare API request
    final uri = Uri.https('platform.fatsecret.com', '/rest/server.api', params);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Food Detailed Description
  Future<dynamic> getFoodDetails(String foodId) async {
    return await fetchData("food.get", {
      'food_id': foodId,
    });
  }
}
