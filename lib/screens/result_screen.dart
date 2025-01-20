import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/quiz_provider.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;
  final List<Map<String, dynamic>> detailedAnalysis;
  final ValueNotifier<bool> showChartNotifier = ValueNotifier(false);
  final ValueNotifier<bool> showPieChartNotifier = ValueNotifier(false);
  final ValueNotifier<bool> showDetailsNotifier = ValueNotifier(false);

  ResultScreen(
      {super.key, required this.result, required this.detailedAnalysis}) {
    _initializeAnimations();
  }

  Future<void> _initializeAnimations() async {
    // Trigger animations in sequence
    await Future.delayed(const Duration(milliseconds: 500));
    showChartNotifier.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    showPieChartNotifier.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    showDetailsNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: (){Navigator.pop(context);},
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Quiz Results',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'You have successfully completed the quiz.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[300],
                    fontFamily: 'Iceland',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildBarChart(),
              const SizedBox(height: 32),
              _buildPieChart(),
              const SizedBox(height: 32),
              _buildResultDetails(),
              const SizedBox(height: 32),
              _buildQuestionDetails(context),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Pacifico'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return ValueListenableBuilder<bool>(
      valueListenable: showChartNotifier,
      builder: (context, show, _) {
        return AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              const Text(
                'Score Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Iceland',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: result.positiveScore,
                            color: Colors.green,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: result.negativeScore,
                            color: Colors.red,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: result.unAnswered.toDouble(),
                            color: Colors.orange,
                            width: 16,
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text('Correct',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Alegreya',
                                    ));
                              case 1:
                                return const Text('Incorrect',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Alegreya',
                                    ));
                              case 2:
                                return const Text('Unanswered',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Alegreya',
                                    ));
                              default:
                                return const Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false), // Disable top titles
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Disable right titles
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPieChart() {
    return ValueListenableBuilder<bool>(
      valueListenable: showPieChartNotifier,
      builder: (context, show, _) {
        return AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              const Text(
                'Answer Distribution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Iceland',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: result.positiveScore,
                        title: 'Correct',
                        color: Colors.green,
                        radius: 50,
                        titleStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                      PieChartSectionData(
                        value: result.negativeScore,
                        title: 'Incorrect',
                        color: Colors.red,
                        radius: 50,
                        titleStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                      PieChartSectionData(
                        value: result.unAnswered.toDouble(),
                        title: 'Unanswered',
                        color: Colors.orange,
                        radius: 50,
                        titleStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Alegreya',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultDetails() {
    return ValueListenableBuilder<bool>(
      valueListenable: showDetailsNotifier,
      builder: (context, show, _) {
        return AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              ResultCard(
                title: 'Total Score',
                value: result.totalScore.toStringAsFixed(2),
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              ResultCard(
                title: 'Correct Answers',
                value: '+${result.positiveScore.toStringAsFixed(2)}',
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              ResultCard(
                title: 'Incorrect Answers',
                value: '-${result.negativeScore.toStringAsFixed(2)}',
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              ResultCard(
                title: 'Unanswered Questions',
                value: '${result.unAnswered}',
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Detailed Question Analysis',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Iceland'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.8,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: detailedAnalysis.length,
            itemBuilder: (context, index) {
              final question = detailedAnalysis[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${question['question']}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alegreya'),
                        ),
                        const SizedBox(height: 8),
                        Text('Topic: ${question['topic']}',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontFamily: 'Alegreya')),
                        const SizedBox(height: 8),
                        Text(
                          'Your Answer: ${question['optedAnswer']}',
                          style: TextStyle(
                              fontSize: 14,
                              color: question['optedAnswer'] ==
                                      question['correctAnswer']
                                  ? Colors.green
                                  : Colors.red,
                              fontFamily: 'Alegreya'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Correct Answer: ${question['correctAnswer']}',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'Alegreya'),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Solution: ${question['detailedSolution']}',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Alegreya'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Alegreya'),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Alegreya'),
            ),
          ],
        ),
      ),
    );
  }
}
