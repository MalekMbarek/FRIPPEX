import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Weather {
  static const String apiKey = 'b82ae0363e1bbea80630608a0d5c37fa'; // ma cle sur openweather
  static const String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Méthode pour récupérer la température en fonction des coordonnées GPS
  Future<double?> getTemperature(Position position) async {
    try {
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Construire l'URL de la requête API
      final url = Uri.parse('$apiUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

      // Faire la requête HTTP
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double temperature = data['main']['temp'];
        return temperature;
      } else {
        print("Erreur lors de la récupération de la météo: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur: $e");
    }
    return null;
  }
}
