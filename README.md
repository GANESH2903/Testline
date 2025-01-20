
# Testline

# Quiz App
A feature-rich Flutter-based quiz application designed for dynamic quizzes with detailed question analysis.
The app includes functionalities such as fetching quizzes from a remote server, tracking user answers,
and presenting results with a detailed breakdown and interactive data visualizations.

Features
- Dynamic Quiz Fetching: Fetch quizzes with questions, topics, and options from a backend API.
- User-Friendly Interface: Clean and intuitive design for seamless interaction.
- Interactive Data Visualization: Analyze results with pie charts and bar charts.
- Detailed Question Analysis: Review your answers, correct answers, and detailed solutions.
- Horizontal Navigation for Analysis: Swipe through detailed question-by-question analysis.
- Persistent State Management: Manage quiz state efficiently using Provider and ChangeNotifier pattern.

Folder Structure
lib/
├── main.dart             # Entry point of the app
├── splash_screen.dart
├── screens/              # Contains all UI screens (e.g., HomePage, quizScreen and ResultScreen)
|   ├── Components/
|   |   ├── bubble_box.dart  # Contains UI for the animated box the displaying question
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   └── results_screen.dart
├── providers/            # State management classes
│   └── quiz_provider.dart
├── services/             # API services and data fetching logic
│   └── quiz_service.dart
assets/               # Lottie animations, images, and other assets


