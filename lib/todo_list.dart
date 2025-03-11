import 'package:flutter/material.dart';
import 'database.dart';
import 'account.dart';
import 'main_menu.dart';
import 'new_todo.dart';
import 'todo_progress.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["All Tasks", "Top Priority", "Low Priority"];
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  void _deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _loadTasks();
  }

  void _toggleTaskCompletion(int id, bool isCompleted) async {
    await DatabaseHelper.instance.updateTask(id, isCompleted);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoProgress()),
                  );
              },
              child: Text("My Progress"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task['isCompleted'] == 1,
                      activeColor: Colors.purple,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(task['id'], value ?? false);
                      },
                    ),
                    title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(task['description']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {
                        _deleteTask(task['id']); 
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
                onPressed: () async {
                  final newTaskId = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewToDo()),
                  );
                  if (newTaskId != null) {
                    _loadTasks();
                  }
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