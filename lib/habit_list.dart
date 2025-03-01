import 'package:flutter/material.dart';
import 'account.dart';
import 'main_menu.dart';
import 'new_habit.dart';
import 'habit_progress.dart';

class HabitList extends StatefulWidget {
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  int selectedDayIndex = 0;
  final List<String> days = [
    "All Days", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ]; // make it scollable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar Section
      appBar: AppBar(
        title: Text("All Habits", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitProgress()),
                );
              },
              child: Text("My Progress"), // Fixed missing comma
            ),
          ),
        ],
      ),

      // Body Section
      body: Column(
        children: [
          // Day Filter Tabs with Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(days.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(days[index]),
                    selected: selectedDayIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10),

          // Habit List
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Example habit items
              itemBuilder: (context, index) {
                return HabitCard();
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue[200],
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavButton(
                icon: Icons.home,
                label: "Home",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainMenu()),
                  );
                },
              ),
              BottomNavButton(
                icon: Icons.add, // Fixed issue
                label: "Add",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NewHabit()),
                  );
                },
              ),
              BottomNavButton(
                icon: Icons.account_circle,
                label: "Account",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Account()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Habit Card Widget (Changed to StatelessWidget)
class HabitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.lightBlue, width: 2),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.repeat, color: Colors.black), // Habit Icon
        title: Text("Menu Label", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Menu description."),
      ),
    );
  }
}

// Bottom Navigation Button Widget
class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const BottomNavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon, size: 28, color: Colors.black),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black)), // Fixed text style error
      ],
    );
  }
}
