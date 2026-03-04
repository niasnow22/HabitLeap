import 'package:flutter/material.dart';
import 'database.dart';
// Ensure this matches your ToDoList file

class NewToDo extends StatefulWidget {
  const NewToDo({super.key});

  @override
  _NewToDoState createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  bool _isAllDay = false;
  String _priority = "High";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveTask() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task description")),
      );
      return;
    }

    String formattedDate = "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}";
    String formattedTime = _isAllDay ? "All Day" : _selectedTime.format(context);

    try {
      await DatabaseHelper.instance.insertTask(
        _descriptionController.text, 
        formattedDate, 
        formattedTime, 
        _priority,
        isCompleted: false, // Default new task to incomplete
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task saved successfully!")),
      );

      Navigator.pop(context, true); // Return success to refresh task list
    } catch (e) {
      print("Error inserting task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save task. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Cancel", style: TextStyle(color: Colors.purple, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "ex: Do math homework, laundry",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Date Picker
            const Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Time Picker
            const Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isAllDay ? "All Day" : _selectedTime.format(context), style: const TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[200]),
                  child: const Text("Select Time", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // All-Day Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("All-Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Switch(
                  value: _isAllDay,
                  onChanged: (value) => setState(() => _isAllDay = value),
                  activeThumbColor: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Priority Selector
            const Text("Priority", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              onChanged: (value) => setState(() => _priority = value!),
              items: const ["High", "Medium", "Low"]
                  .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.check, color: Colors.black),
                label: const Text("Done", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


