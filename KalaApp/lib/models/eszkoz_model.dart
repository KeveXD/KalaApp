class EszkozModel {
  final String eszkozNev;
  final String eszkozAzonosito;
  final String location;
  final String felelosNev;
  final String comment;
  final List<String> megjegyzesek; // Lista a megjegyzésekhez
  final List<String> kepek; // Képek URL-jei

  // Konstruktor
  EszkozModel({
    required this.eszkozNev,
    required this.eszkozAzonosito,
    required this.location,
    required this.felelosNev,
    required this.comment,
    required this.megjegyzesek,
    required this.kepek,
  });

  // ToJson: Az eszköz modell konvertálása egy Map-be (JSON formátumú adat)
  Map<String, dynamic> toJson() {
    return {
      'eszkozNev': eszkozNev,
      'eszkozAzonosito': eszkozAzonosito,
      'location': location,
      'felelosNev': felelosNev,
      'comment': comment,
      'megjegyzesek': megjegyzesek,
      'kepek': kepek,
    };
  }

  // FromJson: JSON adatból eszköz modell létrehozása
  factory EszkozModel.fromJson(Map<String, dynamic> json) {
    return EszkozModel(
      eszkozNev: json['eszkozNev'] ?? '',
      eszkozAzonosito: json['eszkozAzonosito'] ?? '',
      location: json['location'] ?? '',
      felelosNev: json['felelosNev'] ?? '',
      comment: json['comment'] ?? '',
      megjegyzesek: List<String>.from(json['megjegyzesek'] ?? []),
      kepek: List<String>.from(json['kepek'] ?? []),
    );
  }
}
