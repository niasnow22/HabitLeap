import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(HabitLeap());
}

class HabitLeap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLeap',
      debugShowCheckedModeBanner: false, // Hides debug banner
      home: Login(), // Starts with MainMenu
    );
  }
}
