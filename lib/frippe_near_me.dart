import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../data_base/database_frippe.dart';
import '../models/frippe.dart';
import '../models/weather.dart';
import 'vendor_listing.dart';

class FrippeNearMe extends StatefulWidget {
  const FrippeNearMe({super.key});

  @override
  FrippeNearMeState createState() => FrippeNearMeState();
}

class FrippeNearMeState extends State<FrippeNearMe> {
  List<Frippe> _nearbyFrippes = [];
  bool _isLoading = true;
  String _region = '';

  double? _temperature;
  bool _isWeatherLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFrippes();
    _getWeather();
  }

  Future<void> _loadFrippes() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          debugPrint("❌ Permission GPS refusée définitivement");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      String region = await _getRegionFromCoordinates(position);

      setState(() {
        _region = region;
        _isLoading = true;
      });

      List<Frippe> frippes = await DatabaseFrippe.instance
          .getFrippesByRegion(region.toLowerCase().trim());

      setState(() {
        _nearbyFrippes = frippes;
        _isLoading = false;
      });

      debugPrint("✅ ${frippes.length} frippes récupérées pour la région: '$_region'");
    } catch (e) {
      debugPrint("❌ Erreur lors du chargement des frippes: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getRegionFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        return placemarks[0].administrativeArea?.trim().toLowerCase() ?? "inconnue";
      }
    } catch (e) {
      debugPrint("⚠️ Erreur lors de la récupération de la région: $e");
    }
    return "inconnue";
  }

  Future<void> _getWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      Weather weather = Weather();
      double? temp = await weather.getTemperature(position);
      setState(() {
        _temperature = temp;
        _isWeatherLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur lors de la récupération de la météo: $e");
      setState(() {
        _isWeatherLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/frippe_liste.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 25,
            right: 10,
            child: _isWeatherLoading
                ? CircularProgressIndicator()
                : Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                _temperature != null
                    ? ' ${_temperature!.toStringAsFixed(1)}°C'
                    : 'Température non dispo',
                style: const TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "Frippe Near Me",
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Région: $_region',
                style: const TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _nearbyFrippes.isEmpty
                    ? const Center(
                  child: Text(
                    "NO FRIPPE HAS BEEN FOUND",
                    style: TextStyle(
                      fontFamily: 'DancingScript',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: _nearbyFrippes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/cadre_frippe.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _nearbyFrippes[index].name,
                          style: const TextStyle(
                            fontFamily: 'DancingScript',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VendorListingPage()),
          );
        },
        child: Icon(Icons.store),
        backgroundColor: Color(0xFFF2AEBB),
      ),
    );
  }
}
