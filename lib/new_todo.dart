import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_list.dart';

class NewToDo extends StatefulWidget {
  const NewToDo ({super.key});

  @override
  _NewToDoState createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selctedDate = '02/12';
  final String _selectedTime = "8:00 AM";
  final bool _isAllDay = false;
  final String _priority = "High";

  void _saveTask() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a task description")),
      );
      return;
    }

    final newTask = {
      "description": _descriptionController.text,
      "date": _selectedDate,
      "time": _isAllDay ? "All Day" : _selectedTime,
      "priority": _priority,
    };

    await DatabaseHelper.instance.insertTask(newTask);
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.purple, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "ex: do my math homweork, laundry",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple,width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text("Date". style: TextStyle(fontWeight: fontWeight.bold, fontsize: 16)),
            DropdownButtonFormField<String>(
              value: _selctedDate,
              onChanged: (value) => setState(() => _selctedDate = value!), 
               items: ['02/12', '02/13', '02/14']
                  .map(date) => DropdownMenuItem(value: date, child: Text(date)))
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  focusedBorder: OutlineInputBorder(
                    borderSide: borderSide(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ) ,
              SizedBox(height: 12),
              Text("Time", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                onChanged: (value) => setState(() => _selectedTime = value!),
                items: ['8:00 AM', '9:00 AM', '10:00 AM']
                 .map((time) => DropdownMenuItem(value: time,child: Text(time)))
                .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: mainAxisAlignment.spaceBetween,
                children[
                  Text("All-Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Switch(
                    value: _isAllDay,
                    onChanged: (value) => setStyle(() => _isAllDay = value),
                    activeColor: Colors.purple,
                  ),
                ],
              ),
              SizedBox(height:12),
              Text("Priorty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              DropdownButtonFormField<String>(
                value: _priority,
                onChanged: (value) => setState(() => _priority = value!),
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(value: priority, child: Txet(priority)))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)
                  )
                )
              )
              );,
             )
          ],
        ),
      )
    )
  }
