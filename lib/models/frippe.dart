class Frippe {
  final String name; // Nom de la frippe
  final String region; // Région de la frippe

  // Constructeur
  Frippe({
    required this.name,
    required this.region,
  });

  // Convertir une frippe en Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
    };
  }

  // Créer une frippe à partir d'un Map (avec trim et lowercase)
  factory Frippe.fromMap(Map<String, dynamic> map) {
    String cleanedRegion = map['region'].trim().toLowerCase();
    print("📌 Loading Frippe: ${map['name']} - Region: '$cleanedRegion'"); // Debug
    return Frippe(
      name: map['name'],
      region: cleanedRegion,
    );
  }
}
