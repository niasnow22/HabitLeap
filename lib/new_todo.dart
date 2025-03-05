import 'package:flutter/material.dart';
import 'todo_list.dart'; // Ensure this exists and is correctly linked.

class NewToDo extends StatefulWidget {
  @override
  _NewToDoState createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedDate = "02/12";
  String _selectedTime = "8:00 AM";
  bool _isAllDay = false;
  String _priority = "High";

  void _navigateBack() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ToDoList()));
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
              onPressed: _navigateBack,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description Input
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "ex: do my math homework, laundry",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Date Picker Dropdown
            Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              value: _selectedDate,
              onChanged: (value) {
                setState(() => _selectedDate = value!);
              },
              items: ["02/12", "02/13", "02/14"]
                  .map((date) => DropdownMenuItem(value: date, child: Text(date)))
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

            // Time Picker Dropdown
            Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              value: _selectedTime,
              onChanged: (value) {
                setState(() => _selectedTime = value!);
              },
              items: ["8:00 AM", "9:00 AM", "10:00 AM"]
                  .map((time) => DropdownMenuItem(value: time, child: Text(time)))
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

            // All-Day Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All-Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Switch(
                  value: _isAllDay,
                  onChanged: (value) {
                    setState(() => _isAllDay = value);
                  },
                  activeColor: Colors.purple,
                ),
              ],
            ),
            SizedBox(height: 12),

            // Priority Dropdown
            Text("Priority", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              value: _priority,
              onChanged: (value) {
                setState(() => _priority = value!);
              },
              items: ["High", "Medium", "Low"]
                  .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Done Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _navigateBack,
                icon: Icon(Icons.check, color: Colors.black),
                label: Text("Done", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
