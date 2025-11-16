import 'package:flutter/material.dart';
import "data_base/database.dart";
import 'log_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userType = 'client'; // Valeur par défaut

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fonction d'inscription avec affichage d'un message d'erreur/succès
  void _signUp() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Veuillez remplir tous les champs 😠', Colors.pinkAccent);
      return;
    }

    await _dbHelper.insertUser(username, password, _userType);

    if (mounted) {
      _showMessage("Inscription réussie 😊", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    }
  }

  // Fonction pour afficher un message
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/sign_up.png"),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Champ "User name"
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(
                        fontFamily: 'Dancingscript',
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      onSubmitted: (_) => _signUp(),
                      decoration: const InputDecoration(
                        labelText: "User name :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Dancingscript',
                          fontSize: 30,
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Sélection du type d'utilisateur
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                      value: _userType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _userType = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'client', child: Text('Client')),
                        DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                      ],
                      style: const TextStyle(
                        fontFamily: 'Dancingscript',
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: "User Type :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Dancingscript',
                          fontSize: 30,
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Champ "Password"
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'Dancingscript',
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      onSubmitted: (_) => _signUp(),
                      decoration: const InputDecoration(
                        labelText: "Password :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Dancingscript',
                          fontSize: 30,
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bouton d'inscription flottant
          Positioned(
            bottom: 50, // Ajuste cette valeur pour bien positionner le bouton
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Couleur de fond noire
                  foregroundColor: Colors.white, // Couleur du texte blanche
                  minimumSize: const Size(300, 60), // Taille minimale du bouton
                  textStyle: const TextStyle(fontSize: 20), // Taille du texte
                ),
                child: const Text("Sign Up"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
