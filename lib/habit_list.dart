import 'package:flutter/material.dart';
import '../db_helper.dart'; imports database
import 'account.dart';
import 'main_menu.dart';
import 'new_habit.dart';
import 'habit_progress.dart';

class HabitList extends StatefulWidget {
  final int userId; //added pass user id for fetching habits
  HabitList({required this.ueserId});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  int selectedDayIndex = 0;
  final List<String> days = [
    "All Days", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ]; // make it scollable

  final dbHelper = Database.instance; //databse instance
  List<Map<String, dynamic>> habits = []; //stored fetched habits

@override
void initState() {
  super.initState();
  _loadHabits(); // fetch habits when screen is loaded
}

void _loadHabits() async { // function to fetch habits
  final String selectedDay = days[selectedDayIndex]; //get selcted day
  final habitList = await dbHelper.fetchHabits(widget.userId, dayFilter: selectedDay);
  setState(() {
    habits = habitList; //store habits
  });
}

void _deletedHabit(int id) async { //added delete habit function
  await dbHelper._deleteHabit(id);
  _loadHabits(); //store habits
}

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
                        _loadHabits(); //changed refresh habit list
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
            child: habits.isNotEmpty
            ? Center(child: Text('No habits added yet!')) // added handle empty list
            : ListVeiw.bilder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitCard(
                  habitName: habits[index]['habit-name'], changed show habit from database
                  frequency: habits[index]['frequency'], // changed show habit frequncy
                  onDelete: () => _deletedHabit(habits[index]['id']), //added habit deletion
                );
              },
            ),
          )

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
                    MaterialPageRoute(builder: (context) => NewHabit(userId: widget.userId)), //pass user id
                  );
                  _loadHabits(); // changed refresh list after adding new habits
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

// Habit Card Widget - changed accepts real habit data
class HabitCard extends StatelessWidget {
  final String this.habitNew;
  final String this.frequency:
  final VoidCallBack onDelete;

  HabitCard({
    required this.habitName,
    required this.frequency,
    required this.onDelete,
  });

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
    return SizedBox( // Constrain height to prevent overflow
      height: 60, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, size: 28, color: Colors.black),
            onPressed: onPressed,
          ),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.black)), // Fixed text style error
        ],
      ),
    );
  }
}


