import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testline/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    //Splash screen will be displayed for 3 sec
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // After  3 sec Navigating to HomeScreen
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 50, 71),
      body: Center(
        child: Lottie.asset('assets/splashScreen.json', controller: _controller,
            onLoaded: (composition) {
          _controller.duration = composition.duration;
          _controller.forward();
        }, fit: BoxFit.fill),
      ),
    );
  }
}
