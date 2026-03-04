import 'package:flutter/material.dart';
import 'account.dart';
import 'database.dart';
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

    List<Map<String, dynamic>> filteredTasks;
    if (selectedFilterIndex == 1) {
      filteredTasks = data.where((task) => task['priority'] == 'High').toList();
    } else if (selectedFilterIndex == 2) {
      filteredTasks = data.where((task) => task['priority'] == 'Low').toList();
    } else {
      filteredTasks = data;
    }

    setState(() {
      tasks = filteredTasks;
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
        title: const Text("To-Do List", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoProgress()),
                );
              },
              child: const Text("My Progress"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(filters.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(filters[index]),
                    selected: selectedFilterIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilterIndex = index;
                        _loadTasks();
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

          // Task List
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks yet!'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.purple, width: 2),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['isCompleted'] == 1,
                            activeColor: Colors.purple,
                            onChanged: (bool? value) {
                              _toggleTaskCompletion(task['id'], value ?? false);
                            },
                          ),
                          title: Text(
                            task['description'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: task['isCompleted'] == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text("Priority: ${task['priority']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () {
                              _deleteTask(task['id']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[200],
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
                onPressed: () async {
                  final newTaskAdded = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewToDo()),
                  );

                  if (newTaskAdded == true) {
                    _loadTasks(); // Reload the list after adding a task
                  }
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

// Reusable Bottom Navigation Button
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
