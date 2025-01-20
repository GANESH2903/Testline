import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import './quiz_screen.dart';
// This is the Landing Page for the Quiz App , User can click on Start button to start the quiz
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Lottie.asset('assets/playQuiz.json')),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Quiz App',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Test your knowledge and learn new things',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Pacifico', fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: () {
                    context.read<QuizProvider>().loadQuiz();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuizScreen()), // Navigates to QuizScreen and starts the quiz
                    );
                  },
                  child: Lottie.asset('assets/start.json'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
