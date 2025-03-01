import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'account.dart';

class HabitProgress extends StatefulWidget {
  @override
  _HabitProgressState createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  int completedHabits = 6;
  int totalHabits = 10;
  int currentMonthIndex = 1;
  final List<String> months = [
    "January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        title: Text("My Progress", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
      ),

      // Body Section
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Month Selector Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left, size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (currentMonthIndex > 0) {
                        currentMonthIndex--;
                      }
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.lightBlue, width: 2),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(months[currentMonthIndex]),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right, size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (currentMonthIndex < months.length - 1) {
                        currentMonthIndex++;
                      }
                    });
                  },
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
                    value: completedHabits / totalHabits,
                    backgroundColor: Colors.grey[300],
                    color: Colors.lightBlue,
                    strokeWidth: 8,
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "$completedHabits/$totalHabits",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Habit Completed Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {},
              child: Text("Habits Completed", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),

            // Navigation Buttons
            Column(
              children: [
                NavButton(icon: Icons.share, label: "Share", onPressed: () {}),
                SizedBox(height: 10),
                NavButton(
                  icon: Icons.home,
                  label: "Home",
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
                  },
                ),
                SizedBox(height: 10),
                NavButton(
                  icon: Icons.account_circle,
                  label: "Account",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Navigation Button Widget
class NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const NavButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.lightBlue, width: 2),
        ),
      ),
      icon: Icon(icon),
      label: Text(label, style: TextStyle(fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
