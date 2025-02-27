import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage()//add image and put in assests and yaml
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //title section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(15)
              ),
              child: Text(
                "HabitLeap",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  colors: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),

            //Login Form
            Container(
              width: 320,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(15),
                border: Border.all.(color: Colors.orange[700]!),
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

                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleForm(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: Text("Sign In"),
                    ),
                  ),

                  //Forgot Password
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

            // Register Button
            SizedBox(
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleForm(
                  backgroundColor: Colors.purple[300],
                  foregroundColor: Colors.black,
                ),
                onPressed: () {},
                child: Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}