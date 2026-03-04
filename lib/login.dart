import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Habit Leap",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Login Form
            Container(
              width: 320,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange[700]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email", style: TextStyle(color: Colors.black)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Password", style: TextStyle(color: Colors.black)),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainMenu()),
                        );
                      },
                      child: Text("Sign In"),
                    ),
                  ),

                  // Forgot Password
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Register (TextButton inside a styled Container)
Container(
  width: 180,
  decoration: BoxDecoration(
    color: Colors.purple[300], // Keep the purple background
    borderRadius: BorderRadius.circular(10),
  ),
  child: TextButton(
    onPressed: () {
      // Navigate to Register Screen
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => Register()),
      );
    },
    style: TextButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 14), // Keep padding like before
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Ensure button aligns with container
      ),
    ),
    child: Text(
      "Register",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Keep black text color
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
