import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'account.dart';
import 'database.dart';

class ToDoProgress extends StatefulWidget {
  const ToDoProgress({super.key});

  @override
  _ToDoProgressState createState() => _ToDoProgressState();
}

class _ToDoProgressState extends State<ToDoProgress> {
  int _currentProgress = 0;
  int _goal = 1; // Default to avoid division by zero
  String _selectedMonth = "March"; // Default month
  final List<String> _months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  int _monthIndex = 2; // March (0-based index)

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    List<Map<String, dynamic>> tasks = await DatabaseHelper.instance.getTasks();

    // Count completed tasks
    int completedTasks = tasks.where((task) => task['isCompleted'] == 1).length;
    
    // Ensure goal isn't zero to prevent errors
    setState(() {
      _currentProgress = completedTasks;
      _goal = tasks.isNotEmpty ? tasks.length : 1; 
    });
  }

  void _previousMonth() {
    setState(() {
      if (_monthIndex > 0) _monthIndex--;
      _selectedMonth = _months[_monthIndex];
      _loadProgress();
    });
  }

  void _nextMonth() {
    setState(() {
      if (_monthIndex < _months.length - 1) _monthIndex++;
      _selectedMonth = _months[_monthIndex];
      _loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.purple[200],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
                  icon: const Icon(Icons.arrow_left, color: Colors.purple),
                  onPressed: _previousMonth,
                ),
                Text(
                  _selectedMonth,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_right, color: Colors.purple),
                  onPressed: _nextMonth,
                ),
              ],
            ),
            const SizedBox(height: 20),

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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
                Text(
                  "$_currentProgress/$_goal",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // "Tasks Completed" Button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Tasks Completed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            _buildActionsButton("Share", Icons.share, () {
              print("Share clicked");
            }),
            _buildActionsButton("Home", Icons.home, () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainMenu()));
            }),
            _buildActionsButton("Account", Icons.person, () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const Account()));
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
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.purple),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        ),
      ),
    );
  }
}
