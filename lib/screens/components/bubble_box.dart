import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

// This UI is for displaying questions.
class DynamicBubble extends StatelessWidget {
  final String text;
  final int texdId;

  const DynamicBubble({super.key, required this.text, required this.texdId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: Colors.black, width: 2),
        ),
        padding: const EdgeInsets.all(16.0),
        child: AnimatedTextKit(
          key: ValueKey(texdId),
          animatedTexts: [
            TypewriterAnimatedText(
              text,
              textStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Alegreya',
              ),
              speed: const Duration(milliseconds: 50),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 500),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }
}