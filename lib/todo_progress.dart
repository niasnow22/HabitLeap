import 'package:flutter/material.dart';
import 'main_menu.dart';  // Ensure this exists
import 'account.dart';    // Ensure this exists

class ToDoProgress extends StatefulWidget {
  @override
  _ToDoProgressState createState() => _ToDoProgressState();
}

class _ToDoProgressState extends State<ToDoProgress> {
  int _currentProgress = 6;
  int _goal = 10;
  String _selectedMonth = "February";

  void _previousMonth() {
    setState(() {
      _selectedMonth = "January"; // Placeholder for actual month logic
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = "March"; // Placeholder for actual month logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Progress", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.purple[200],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black), // Makes back button black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Month Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, color: Colors.purple),
                  onPressed: _previousMonth,
                ),
                Text(
                  _selectedMonth,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, color: Colors.purple),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _currentProgress / _goal,
                    strokeWidth: 8,
                    backgroundColor: Colors.purple[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
                Text(
                  "$_currentProgress/$_goal",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20),

            // "Habits Completed" Button
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Habits Completed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),

            // Action Buttons
            _buildActionsButton("Share", Icons.share, () {
              print("Share clicked");
            }),
            _buildActionsButton("Home", Icons.home, () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainMenu())); // Path to Home
            }),
            _buildActionsButton("Account", Icons.person, () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Account())); // Path to Account
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.purple),
        label: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.purple),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        ),
      ),
    );
  }
}
