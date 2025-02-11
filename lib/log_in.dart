import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/log_in_page.png"), // Background image
            fit: BoxFit.cover, // Ensure the image covers the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              // User name field
              TextField(
                style: TextStyle(fontFamily: 'AdamScript', fontSize: 25, color: Colors.black), // Font size changed to 25
                decoration: InputDecoration(
                  labelText: "User name",
                  labelStyle: TextStyle(color: Colors.black, fontFamily: 'AdamScript', fontSize: 25), // Font size changed to 25
                  border: InputBorder.none, // Removed border
                  filled: true,
                  fillColor: Colors.white.withValues(), // Semi-transparent white background
                ),
              ),
              SizedBox(height: 20), // Space between the fields
              // Password field
              TextField(
                style: TextStyle(fontFamily: 'AdamScript', fontSize: 25, color: Colors.black), // Font size changed to 25
                obscureText: true, // Hide the text for password
                decoration: InputDecoration(
                  labelText: "PassWord",
                  labelStyle: TextStyle(color: Colors.black, fontFamily: 'AdamScript', fontSize: 25), // Font size changed to 25
                  border: InputBorder.none, // Removed border
                  filled: true,
                  fillColor: Colors.white.withValues(), // Semi-transparent white background
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
