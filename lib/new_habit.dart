import 'package:flutter/material.dart';
import 'habit_list.dart';

class NewHabit extends StatefulWidget {
  @override
  _NewHabitState createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  final TextEditingController afterController = TextEditingController();
  final TextEditingController willController = TextEditingController();
  int selectedDayIndex = 0;
  final List<String> days = ["All Days", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      //AppBar
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
                  //Save habit logic here
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => HabitList()),
                  );
                },
              child: Text("Cancel"),
            ),
          )
        ],
      ),

      //Body 
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //After I..
            Text("After I,", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: afterController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "ex: brushing my teeth, homework",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
            ),
            SizedBox(height: 20),

            //I will....
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


            //Reminder Days Selected
            Text("What days do you need to be remineded?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Divider(color: Colors.black,),
            SizedBox(height: 10),

            //Day filter tabs with scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(days.length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(days[index]),
                      selected: selectedDayIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDayIndex == index;
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

            //Done Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ) ,
                icon: Icon(Icons.check_box, color: Colors.black),
                label: Text("Done", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  //Save habit logic here
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => HabitList()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}