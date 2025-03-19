class MegjegyzesModel {
  final String azonosito;
  final String emailCim;
  final String felhasznaloNev;
  final String megjegyzes;
  final String datum; // ISO 8601 formátumban tároljuk

  MegjegyzesModel({
    required this.azonosito,
    required this.emailCim,
    required this.megjegyzes,
    required this.datum,
    required this.felhasznaloNev
  });

  // JSON konvertálás
  Map<String, dynamic> toJson() {
    return {
      'azonosito': azonosito,
      'emailCim': emailCim,
      'megjegyzes': megjegyzes,
      'datum': datum,
      'felhasznaloNev': felhasznaloNev, // Új mező az felhasználónév'
    };
  }

  // JSON-ból objektummá alakítás
  factory MegjegyzesModel.fromJson(Map<String, dynamic> json) {
    return MegjegyzesModel(
      felhasznaloNev: json['felhasznaloNev'] ?? '',
      azonosito: json['azonosito'] ?? '',
      emailCim: json['emailCim'] ?? '',
      megjegyzes: json['megjegyzes'] ?? '',
      datum: json['datum'] ?? '',
    );
  }
}

// EszkozModel frissítve MegjegyzesModel listával
