import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGptRecipeService {
  final String apiKey =
      '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';

  Future<Map<String, dynamic>> fetchRecipeFridgeAi(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content": "You are a recipe suggestion assistant."
          },
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 2048,
        "temperature": 0.7,
        "response_format": {
          "type": "json_schema",
          "json_schema": {
            "name": "recipes_schema",
            "strict": true,
            "schema": {
              "type": "object",
              "properties": {
                "recipes": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "title": {"type": "string"},
                      "description": {"type": "string"},
                      "ingredients": {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "properties": {
                            "ingredient": {"type": "string"},
                            "quantity": {"type": "string"}
                          },
                          "required": ["ingredient", "quantity"],
                          "additionalProperties": false
                        }
                      },
                      "steps": {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "properties": {
                            "instruction": {"type": "string"}
                          },
                          "required": ["instruction"],
                          "additionalProperties": false
                        }
                      },
                      "calories": {"type": "number"},
                      "recipeTime": {"type": "string"},
                      "nutritionValue": {
                        "type": "object",
                        "properties": {
                          "servings": {"type": "integer"},
                          "protein": {"type": "string"},
                          "carbohydrates": {"type": "string"},
                          "fat": {"type": "string"},
                          "fiber": {"type": "string"}
                        },
                        "required": [
                          "servings",
                          "protein",
                          "carbohydrates",
                          "fat",
                          "fiber"
                        ],
                        "additionalProperties": false
                      }
                    },
                    "required": [
                      "title",
                      "description",
                      "ingredients",
                      "steps",
                      "calories",
                      "recipeTime",
                      "nutritionValue"
                    ],
                    "additionalProperties": false
                  }
                }
              },
              "required": ["recipes"],
              "additionalProperties": false
            }
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load fetchRecipeFridgeAi');
    }
  }

  Future<String> generateRecipeImage(String description) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "dall-e-2",
        "prompt": description,
        "n": 1,
        "size": "1024x1024"
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0]['url'];
    } else {
      throw Exception('Failed to generate image');
    }
  }
}
