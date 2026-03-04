import 'package:flutter/material.dart';
import 'account.dart';
import 'todo_list.dart';
import 'habit_list.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Habit Tracker Button
            MenuButton(
              label: "Habit Tracker",
              color: Colors.lightBlue[300]!,
              borderColor: Colors.lightBlue[700]!,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HabitList(userId: 1)), // Assuming userId is 1
                );
              },
            ),
            const SizedBox(height: 20),

            // To-Do List Button
            MenuButton(
              label: "To-Do List",
              color: Colors.purple[300]!,
              borderColor: Colors.purple[700]!,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoList()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Account Button
            MenuButton(
              label: "Account",
              color: Colors.orange[300]!,
              borderColor: Colors.orange[700]!,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Account()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Menu Button Widget
class MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}