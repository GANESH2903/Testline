import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import './result_screen.dart';
import 'components/bubble_box.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Quiz',
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Listens data from the QuizProvider and act according to it.
          Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              //Loading while fetching the data.
              if (quizProvider.isLoading) {
                return Center(
                    child: SizedBox(
                        height: 250,
                        child: Lottie.asset('assets/quizLauncher.json')));
              }
              //Display related error , if there is an error while fetching data
              if (quizProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 250,
                          child: Lottie.asset('assets/networkError.json')),
                      ElevatedButton(
                        onPressed: () => quizProvider.loadQuiz(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            fontFamily: 'Pacifico',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // If there is no quiz found
              if (quizProvider.quiz == null) {
                return const Center(
                    child: Text(
                  'No quiz available',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                  ),
                ));
              }

              final question = quizProvider.currentQuestion;
              // Quiz UI
              return Stack(
                children: [
                  // Background Animation
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Lottie.asset('assets/background1.json'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Displays the progress of questions completed.
                        FAProgressBar(
                          currentValue:
                              (quizProvider.currentQuestionIndex + 1) *
                                  100 /
                                  quizProvider.quiz['questions'].length,
                          maxValue: 100,
                          size: 12,
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: Colors.grey.shade300,
                          progressColor: Colors.blue,
                          animatedDuration: const Duration(milliseconds: 500),
                        ),
                        const SizedBox(height: 24),
                        //Displays the current question number.
                        Text(
                          'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.quiz['questions'].length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Pacifico',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                //Displays the current question description.
                                Row(
                                  children: [
                                    Lottie.asset('assets/duo_interviewer.json'),
                                    Expanded(
                                      child: DynamicBubble(
                                        text: question['description'],
                                        texdId: question['id'],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // Displays the options for the related question.
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: question['options'].length,
                                  itemBuilder: (context, index) {
                                    final option = question['options'][index];
                                    final isSelected = quizProvider
                                            .userAnswers[question['id']] ==
                                        option['id'];

                                    return GestureDetector(
                                      onTap: () => quizProvider
                                          .answerQuestion(option['id']),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue.shade50
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.blue
                                                : Colors.grey.shade300,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 6,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.blue
                                                      : Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? const Icon(Icons.check,
                                                      color: Colors.white,
                                                      size: 16)
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                option['description'],
                                                style: TextStyle(
                                                  fontFamily: 'Alegreya',
                                                  fontSize: 16,
                                                  color: isSelected
                                                      ? Colors.blue.shade900
                                                      : Colors.black87,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Save and Next Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Logic for Save and Next Button
                            if (!(quizProvider.currentQuestionIndex + 1 >=
                                quizProvider.quiz['questions'].length)) ...[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: (quizProvider.userAnswers
                                        .containsKey(question['id']))
                                    ? () {
                                        quizProvider.nextQuestion();
                                      }
                                    : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Save & Next',
                                      style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                elevation: 5,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              //Logic for Next and submit button.
                              onPressed: (quizProvider.currentQuestionIndex +
                                          1 >=
                                      quizProvider.quiz['questions'].length)
                                  ? (question['is_mandatory'] &&
                                          !(quizProvider.userAnswers
                                              .containsKey(question['id'])))
                                      ? null
                                      : () {
                                // Navigate to Result screen once the test has been submitted.
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultScreen(
                                                result: quizProvider
                                                    .getQuizResult(),
                                                detailedAnalysis: quizProvider
                                                    .getDetailedAnalysis,
                                              ),
                                            ),
                                          );
                                        }
                                  : question['is_mandatory']
                                      ? null
                                      : () {
                                          quizProvider.nextQuestion();
                                        },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    quizProvider.currentQuestionIndex + 1 >=
                                            quizProvider
                                                .quiz['questions'].length
                                        ? Icons.check_circle
                                        : Icons.navigate_next,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    quizProvider.currentQuestionIndex + 1 >=
                                            quizProvider
                                                .quiz['questions'].length
                                        ? 'Submit'
                                        : 'Next',
                                    style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // This is bot , which can be implemented in future for improving user interaction with AI.
          Positioned(
            bottom: 0,
            right: -25,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 150, // Set the height
                width: 150, // Set the width
                child: Lottie.asset('assets/bot.json', fit: BoxFit.fill),
              ),
            ),
          )
        ],
      ),
    );
  }
}
