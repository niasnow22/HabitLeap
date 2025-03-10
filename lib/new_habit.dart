import 'package:flutter/material.dart';
import 'database.dart';
import 'habit_list.dart';

class NewHabit extends StatefulWidget {
  const NewHabit({super.key});

  @override
  _NewHabitState createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  final TextEditingController afterController = TextEditingController();
  final TextEditingController willController = TextEditingController();
  int selectedDay = 0;
  final List<String> days = ['AllDays', "Monday", 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'habits.db'), // Fixed function name
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, after TEXT, will TEXT, day TEXT)'
        );
      },
      version: 1,
    );
  }

  Future<void> addHabit() async {
    final db = await getDatabase();
    await db.insert(
      'habits',
      {
        'after': afterController.text,
        'will': willController.text,
        'day': days[selectedDay] // Fixed variable name
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Habit", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Fixed function name
              },
              child: Text('Cancel'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('After I,', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: afterController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'ex: brushing my teeth, homework',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("I will,", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: willController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "ex: make my bed, do the dishes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("What days do you need to be reminded?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(days.length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(days[index]),
                      selected: selectedDay == index, // Fixed variable name
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDay = index; // Fixed syntax
                        });
                      },
                      selectedColor: Colors.lightBlue[100],
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.check_box, color: Colors.black),
                label: Text("Done", style: TextStyle(fontSize: 18)),
                onPressed: () async {
                  if (afterController.text.isNotEmpty && willController.text.isNotEmpty) {
                    await addHabit();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HabitList()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in both fields')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
