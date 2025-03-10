import 'package:flutter/material.dart';
import 'database.dart';
import 'account.dart';
import 'main_menu.dart';
import 'new_habit.dart';
import 'habit_progress.dart';

class HabitList extends StatefulWidget {
  final int userId;
  const HabitList({super.key, required this.userId});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  int selectedDayIndex = 0;
  final List<String> days = [
    "All Days", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  final dbHelper = Database.instance;
  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() async {
    final String selectedDay = days[selectedDayIndex];
    final habitList = await dbHelper.fetchHabits(widget.userId, dayFilter: selectedDay);
    setState(() {
      habits = habitList;
    });
  }

  void _deleteHabit(int id) async {
    await dbHelper.deleteHabit(id); _loadHabits();
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("All Habits", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                  context,
                  MaterialPageRoute(builder: (context) => const HabitProgress()),
                );
              },
              child: const Text("My Progress"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(days.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(days[index]),
                    selected: selectedDayIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDayIndex = index;
                        _loadHabits();
                      });
                    },
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: habits.isEmpty
              ? const Center(child: Text('No habits added yet!'))
              : ListView.builder(itemCount: habits.length, physics: const BouncingScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    return HabitCard(habitName: habits[index]['habit_name'] ?? 'Unnamed Habit',
                      habitName: habits[index]['habit_name'],
                      frequency: habits[index]['frequency'],
                      onDelete: () => _deleteHabit(habits[index]['id']),
                    );
                  },
                ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavButton(
                icon: Icons.home,
                label: "Home",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainMenu()),
                  );
                },
              ),
              BottomNavButton(
                icon: Icons.add,
                label: "Add",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewHabit(userId: widget.userId)),
                  ).then((_) => _loadHabits());
                },
              ),
              BottomNavButton(
                icon: Icons.account_circle,
                label: "Account",
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
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String habitName;
  final String frequency;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habitName,
    required this.frequency,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.lightBlue, width: 2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.repeat, color: Colors.black),
        title: Text(habitName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Frequency: $frequency"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const BottomNavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, size: 28, color: Colors.black),
            onPressed: onPressed,
          ),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
