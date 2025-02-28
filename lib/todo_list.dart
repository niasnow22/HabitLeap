import 'package:flutter/material.dart';
import 'account.dart';
import 'main_menu.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["All Tasks", "Top Priority", "Low Priority"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              onPressed: () {
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoProgress()),
                  );
              },
              child: Text("My Progress"),
            ),
          ),
        ],
      ),

      // Body
      body: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(filters.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(filters[index]),
                    selected: selectedFilterIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilterIndex = index;
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

          // Task List inside a Bordered Box
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 5, // Example tasks
                itemBuilder: (context, index) {
                  return ToDoTask();
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[200],
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
                icon: Icons.add,
                label: "Add",
                onPressed: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NewToDo()),
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

// To-Do Task Widget (Checkbox enabled)
class ToDoTask extends StatefulWidget {
  @override
  _ToDoTaskState createState() => _ToDoTaskState();
}

class _ToDoTaskState extends State<ToDoTask> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        activeColor: Colors.purple,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false;
          });
        },
      ),
      title: Text("Task Label", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Task description"),
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
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }
}
