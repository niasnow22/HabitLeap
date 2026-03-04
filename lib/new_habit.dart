import 'package:flutter/material.dart';
import 'database.dart';

class NewHabit extends StatefulWidget {
  final int userId;
  const NewHabit({super.key, required this.userId});

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  final TextEditingController afterController = TextEditingController();
  final TextEditingController willController = TextEditingController();

  int selectedDay = 0;
  final List<String> days = [
    'All Days',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void dispose() {
    afterController.dispose();
    willController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    final afterText = afterController.text.trim();
    final willText = willController.text.trim();

    if (afterText.isEmpty || willText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    try {
      await DatabaseHelper.instance.addHabit(
        widget.userId,
        afterText,
        willText,
        'Daily',
        days[selectedDay],
      );

      if (!mounted) return;
      Navigator.pop(context, true); // ✅ return success
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save habit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Habit', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.lightBlue, width: 2),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('After I,',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: afterController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'ex: brushing my teeth',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('I will,',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: willController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'ex: make my bed',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('What days do you need to be reminded?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(days.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(days[index]),
                      selected: selectedDay == index,
                      onSelected: (_) {
                        setState(() => selectedDay = index);
                      },
                      selectedColor: Colors.lightBlue[100],
                      backgroundColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveHabit,
                icon: const Icon(Icons.check_box, color: Colors.black),
                label:
                    const Text('Done', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
