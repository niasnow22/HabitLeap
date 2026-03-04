import 'package:flutter/material.dart';
import 'main_menu.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState () => _AccountState();
}

class _AccountState extends State<Account> {
  bool notificationEnabled = false; //State fro switch toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        centerTitle: true,
        backgroundColor: Colors.orange[200],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Change Email Field
            Text("Change Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                hintText: "Value",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),

            //Change Password Field
            Text("Change Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "value",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            // Notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Switch(
                  value: notificationEnabled,
                  activeThumbColor: Colors.orange[700],
                  onChanged: (bool value) {
                    setState(() {
                      notificationEnabled = value;
                    });
                  },
                ),
              ],
            ),

            //Share Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.share),
                label: Text("Share", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  // implement share function
                },
              ),
            ),
            SizedBox(height: 15),

            //Home Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.home),
                label: Text("Home", style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => MainMenu()),
                  );
                },
              ),
            )
          ],
        ),
        ),
    );
  }
}