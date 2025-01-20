import 'package:flutter/material.dart';
import '../services/quiz_service.dart';

// QuizProvider for state management.
class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  dynamic _quiz;
  int _currentQuestionIndex = 0;
  Map<int, int> _userAnswers = {};
  bool _isLoading = false;
  String? _error;

  dynamic get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isQuizCompleted =>
      _quiz != null && _currentQuestionIndex >= _quiz['questions'].length;

  dynamic get currentQuestion =>
      (_quiz != null && _currentQuestionIndex < _quiz['questions'].length)
          ? _quiz['questions'][_currentQuestionIndex]
          : null;

  Map<int, int> get userAnswers => _userAnswers;

  // Login for loading quiz
  Future<void> loadQuiz() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quiz = await _repository.getQuiz();
      _currentQuestionIndex = 0;
      _userAnswers = {};
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logic for setting answers when user select the option.
  void answerQuestion(int optionId) {
    if (_quiz == null || isQuizCompleted) return;

    _userAnswers[currentQuestion['id']] = optionId;
    notifyListeners();
  }

  // Logic to display next question
  void nextQuestion() {
    if (isQuizCompleted) return;

    if (_currentQuestionIndex + 1 < _quiz['questions'].length) {
      _currentQuestionIndex++;
    }
    notifyListeners();
  }

  // Sets the result when quiz completes
  QuizResult getQuizResult() {
    if (_quiz == null) return QuizResult(0, 0, 0 , 0);

    final result = _quiz['questions'].map((question) {
      if (!_userAnswers.containsKey(question['id'])) {
        return {
          'correct': 0,
          'incorrect': 0,
          'unanswered': 1,
        };
      }

      final userAnswer = _userAnswers[question['id']]!;
      final correctOption = question['options']
          .firstWhere(
              (opt) => opt['is_correct'] == true,
          orElse: () => {}
      );

      if (correctOption.isEmpty) {
        return {
          'correct': 0,
          'incorrect': 0,
          'unanswered': 1,
        };
      }

      final isCorrect = userAnswer == correctOption['id'];
      return {
        'correct': isCorrect ? 1 : 0,
        'incorrect': isCorrect ? 0 : 1,
        'unanswered': 0,
      };
    }).toList();

    // Using fold to aggregate the results
    final aggregatedResults = result.fold({
      'correct': 0,
      'incorrect': 0,
      'unanswered': 0,
    }, (accumulated, current) {
      accumulated['correct'] += current['correct'];
      accumulated['incorrect'] += current['incorrect'];
      accumulated['unanswered'] += current['unanswered'];
      return accumulated;
    });

    final correct = aggregatedResults['correct'] as int;
    final incorrect = aggregatedResults['incorrect'] as int;
    final unAnswered = aggregatedResults['unanswered'] as int;

    return QuizResult(
      correct * double.parse(_quiz['correct_answer_marks']),
      incorrect * double.parse(_quiz['negative_marks']),
      (correct * double.parse(_quiz['correct_answer_marks'])) -
          (incorrect * double.parse(_quiz['negative_marks'])),
        unAnswered.toDouble()
    );
  }

  // Sets complete detailed result when quiz completes.
  List<Map<String, dynamic>> get getDetailedAnalysis {
    if (_quiz == null) return [];

    return _quiz['questions'].map<Map<String, dynamic>>((question) {
      final userAnswerId = _userAnswers[question['id']];
      final userAnswer = userAnswerId != null
          ? question['options']
          .firstWhere((opt) => opt['id'] == userAnswerId, orElse: () => {})
          : {};

      final correctOption = question['options']
          .firstWhere((opt) => opt['is_correct'] == true, orElse: () => {});

      return {
        'question': question['description'],
        'topic': question['topic'],
        'optedAnswer': userAnswer.isNotEmpty ? userAnswer['description'] : 'Not Answered',
        'correctAnswer': correctOption.isNotEmpty ? correctOption['description'] : 'No Correct Answer',
        'detailedSolution': question['detailed_solution'] ?? "NA",
      };
    }).toList();
  }

}

// Quiz result model for the displaying result analysis graphs.
class QuizResult {
  final double positiveScore;
  final double negativeScore;
  final double totalScore;
  final double unAnswered;

  QuizResult(this.positiveScore, this.negativeScore, this.totalScore , this.unAnswered);
}
