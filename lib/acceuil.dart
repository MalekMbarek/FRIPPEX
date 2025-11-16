import 'package:flutter/material.dart';
import 'sign_up.dart';  // Import the sign-up page
import 'log_in.dart';   // Import the log-in page
import 'frippe_near_me.dart'; // Adjust the path if needed

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/acceuil.png"),
            fit: BoxFit.cover, // Couvre tout l'écran
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns the buttons to the top initially
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              Spacer(), // This will push the buttons down
              // First button: Navigate to sign_up.dart
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to SignUpPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background
                  shadowColor: Colors.transparent, // No shadow
                  padding: EdgeInsets.zero, // Remove padding to fit the image size
                ),
                child: Image.asset(
                  'assets/button_1.png',
                  width: 500,
                  height: 122,
                ),
              ),
              SizedBox(height: 17), // Space between buttons
              // Second button: Navigate to log_in.dart
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()), // Navigate to LogInPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: Image.asset(
                  'assets/button_2.png',
                  width: 500,
                  height: 122,
                ),
              ),
              SizedBox(height: 17), // Space between buttons
              // Third button: Does nothing for now
              // Third button: Navigate to FrippeNearMe
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FrippeNearMe()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: Image.asset(
                  'assets/button_3.png',
                  width: 500,
                  height: 122,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}