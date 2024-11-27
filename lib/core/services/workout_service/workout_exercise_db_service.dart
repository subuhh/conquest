import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseService {
  final String baseUrl = 'https://exercisedb.p.rapidapi.com';
  final String apiKey = dotenv.get('EXERCISE_DB_API_KEY');
  final String host = 'exercisedb.p.rapidapi.com';

  Future<List<dynamic>> fetchExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/bodyPart/$bodyPart'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': host,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _handleHttpError(response);
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Failed to load exercises by body part: $e');
    }
  }

  Future<List<dynamic>> fetchAllExercises() async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': host,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<dynamic>> fetchExercisesByTarget(String target) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises/target/$target'),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': host,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  // New method to search exercises by name
  Future<List<dynamic>> fetchExerciseByName(String exerciseName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/name/$exerciseName'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': host,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _handleHttpError(response);
        throw Exception('Failed to load exercises by name');
      }
    } catch (e) {
      throw Exception('Failed to load exercises by name: $e');
    }
  }

  void _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not found: ${response.body}');
      case 500:
        throw Exception('Internal server error: ${response.body}');
      default:
        throw Exception(
            'Unexpected error: ${response.statusCode} ${response.body}');
    }
  }
}
