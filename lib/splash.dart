import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the loading package
import 'login.dart'; // Ensure this file exists

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller for fading effect
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Longer fading time
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward(); // Start animation

    // Delayed transition to Login screen after 8 seconds
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) { // ✅ Prevents errors if the widget is disposed
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Login(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0); // ✅ Fixed transition offsets
              var end = Offset.zero;
              var curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: Duration(milliseconds: 800), // Adjust transition duration
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title Text
              Text(
                "Habit Leap",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 30),

              // Animated Loading Indicator with Bee Icon in the Middle
              Stack(
                alignment: Alignment.center,
                children: [
                  SpinKitRing(
                    color: Colors.orange, // Matches your reference image
                    size: 115, // Adjust size as needed
                    lineWidth: 2.5, // ✅ Ensures thin lines
                  ),
                  Icon(
                    Icons.emoji_nature_sharp,
                    size: 50, // ✅ Fixed missing size
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up the animation
    super.dispose();
  }
}
