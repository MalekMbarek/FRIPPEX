import 'package:flutter/material.dart';
import "data_base/database.dart";
import 'frippe_near_me.dart'; // Page pour les clients
import 'vendors.dart'; // Page pour les vendeurs
import 'sign_up.dart'; // Page d'inscription
import 'vendor_setup.dart'; // Page de configuration des vendeurs

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fonction de connexion
  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return; // Vérification des champs vides

    String? userType = await _dbHelper.getUserType(username, password);

    if (!mounted) return; // Vérifie si le widget est toujours dans l'arbre

    if (userType != null) {
      if (userType == 'client') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FrippeNearMe()),
        );
      } else if (userType == 'vendor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VendorSetupPage(username: username)), // Garde ton VendorSetupPage
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/log_in_page.png"), // Image de fond
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
                  const SizedBox(height: 20),
                  // Champ "User name"
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _usernameController,
                      style: const TextStyle(
                        fontFamily: 'Dancingscript',
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: "User name :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Dancingscript',
                          fontSize: 40,
                        ),
                        border: InputBorder.none, // Supprime la bordure
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Champ "Password"
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                        fontFamily: 'Dancingscript',
                        fontSize: 40,
                        color: Colors.black,
                      ),
                      obscureText: true, // Cache le texte du mot de passe
                      decoration: const InputDecoration(
                        labelText: "Password :",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Dancingscript',
                          fontSize: 40,
                        ),
                        border: InputBorder.none, // Supprime la bordure
                      ),
                      onSubmitted: (_) => _login(), // Déclenche la connexion dès validation
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bouton de connexion flottant
          Positioned(
            bottom: 50, // Ajuster cette valeur pour la position du bouton
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Couleur de fond noire
                  foregroundColor: Colors.white, // Couleur du texte blanche
                  minimumSize: const Size(300, 60), // Taille minimale du bouton
                  textStyle: const TextStyle(fontSize: 20), // Taille du texte
                ),
                child: const Text("Log in"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
