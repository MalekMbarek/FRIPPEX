import 'package:flutter/material.dart';

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
      ),
    );
  }
}

