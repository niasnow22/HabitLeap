import 'package:flutter/material.dart';
import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Title Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightBlue[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 30),

          // Registration Form 
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
                //Email Field
                Text("Email", style: TextStyle(color: Colors.black)),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                ),
                SizedBox(height: 15),

                //Password Field
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

                //Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.black,
                    ),

                    onPressed: () {
                      //Registration Logic here
                    },
                    child: Text("Register"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Already have an Account? - Section
Container(
  width: 220,
  padding: EdgeInsets.symmetric(vertical: 14),
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.purple[300], // Keep background color
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      Text(
        "Already have an Account?",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
        child: Text(
          "Sign in",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Darker purple for contrast
        ),
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}
