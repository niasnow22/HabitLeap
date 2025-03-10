import 'package:flutter/material.dart';
import 'splash.dart';

void main() {
  runApp(HabitLeap());
}

class HabitLeap extends StatelessWidget {
  const HabitLeap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLeap',
      debugShowCheckedModeBanner: false, // Hides debug banner
      home: Splash(), // Starts with MainMenu
    );
  }
}
