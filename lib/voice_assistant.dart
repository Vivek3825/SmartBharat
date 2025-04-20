import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApi {
  static const String apiKey = 'AIzaSyCGqbNZEQ2XrNnHM8p855nYIDjhtX5Ytto';
  static const String endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro-001:generateContent?key=$apiKey';

  /// Sends [prompt] to Gemini API and returns a short response in the target language.
  static Future<String> getGeminiResponse(String prompt, {String? languageCode}) async {
    String finalPrompt = prompt;
    if (languageCode != null && languageCode.isNotEmpty && languageCode.toLowerCase() != 'english' && languageCode.toLowerCase() != 'en') {
      finalPrompt = 'Answer in short and in $languageCode: $prompt';
    } else {
      finalPrompt = 'Answer in short: $prompt';
    }
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': finalPrompt}
          ]
        }
      ]
    });
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final text = candidates[0]['content']['parts'][0]['text'] as String?;
        return text ?? 'No response.';
      }
      return 'No candidates found.';
    } else {
      return 'Error: \n${response.body}';
    }
  }
}
