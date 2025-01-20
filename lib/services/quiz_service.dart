import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {

  static const String baseUrl = 'https://api.jsonserve.com/Uw5CrX'; // api endpoint

  final http.Client _client;

  QuizService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchQuiz() async {
    try {
      final response = await _client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class QuizRepository {
  final QuizService _quizService;

  QuizRepository({QuizService? quizService})
      : _quizService = quizService ?? QuizService();

  Future<Map<String, dynamic>> getQuiz() async {
    try {
      return await _quizService.fetchQuiz();
    } catch (e) {
      // Handle or rethrow error
      rethrow;
    }
  }
}
