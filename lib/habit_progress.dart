import 'package:flutter/material.dart';
import 'database.dart';
import 'main_menu.dart';
import 'account.dart';

class HabitProgress extends StatefulWidget {
  const HabitProgress({super.key});

  @override
  State<HabitProgress> createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  int completedHabits = 0;
  int totalHabits = 0;
  int currentMonthIndex = DateTime.now().month - 1;

  final List<String> months = [
    "January",
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _loadHabitData();
  }

  Future<void> _loadHabitData() async {
    // If you have user accounts and want per-user progress,
    // you should pass a userId into HabitProgress and use it here.
    // For now, we load ALL habits (matches your old db.query('habits')).

    final habits = await DatabaseHelper.instance.fetchAllHabits();

    setState(() {
      totalHabits = habits.length;
      completedHabits = habits.where((h) => (h['completed'] == true)).length;
    });
  }

  Future<void> markAllHabitsCompleted() async {
    await DatabaseHelper.instance.markAllHabitsCompletedAllUsers();
    await _loadHabitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Progress", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 30, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      if (currentMonthIndex > 0) currentMonthIndex--;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.lightBlue[700]!, width: 2),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(months[currentMonthIndex]),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      size: 30, color: Colors.black),
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
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: totalHabits > 0 ? completedHabits / totalHabits : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.lightBlue),
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200],
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                await markAllHabitsCompleted();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All habits marked as completed!')),
                );
              },
              child: const Text("Mark All Habits Completed",
                  style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                NavButton(icon: Icons.share, label: "Share", onPressed: () {}),
                const SizedBox(height: 10),
                NavButton(
                  icon: Icons.home,
                  label: "Home",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainMenu()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                NavButton(
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
          ],
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.lightBlue, width: 2),
        ),
      ),
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
