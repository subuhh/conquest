import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ExerciseService {
  final String baseUrl = 'https://exercisedb.p.rapidapi.com';
  final String apiKey = dotenv.get('EXERCISE_DB_API_KEY');
  final String host = 'exercisedb.p.rapidapi.com';

  Future<List<dynamic>> fetchExercisesByBodyPart(String bodyPart) async {
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
      throw Exception('Failed to load exercises');
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
}
