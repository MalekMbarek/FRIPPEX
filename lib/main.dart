import 'package:flutter/material.dart';
//import 'sign_up.dart';  // Import the SignUpPage
//import 'log_in.dart';   // Import the LogInPage
import 'acceuil.dart';   // Import your HomePage file
import 'frippe_near_me.dart';  // Adjust the path if it's in another folder
import '../data_base/database.dart';   // Import your HomePage file



void main()  {
  runApp(MyApp());
  // Delete the database file (do this ONLY once during development) plus rod el main asych
  //await DatabaseHelper().deleteDatabaseFile();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
