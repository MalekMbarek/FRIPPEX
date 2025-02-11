import 'package:flutter/material.dart';
//import 'sign_up.dart';  // Import the SignUpPage
//import 'log_in.dart';   // Import the LogInPage
import 'acceuil.dart';   // Import your HomePage file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
