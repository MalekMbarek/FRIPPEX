import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);  // Added key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,  // Set background color to pink
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.pinkAccent,  // Match the app bar color
      ),
      body: Center(
        child: Text(
          'Sign Up Page',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
