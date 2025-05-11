class MegjegyzesModel {
  final String azonosito;
  final String emailCim;
  final String felhasznaloNev;
  final String megjegyzes;
  final String datum;

  MegjegyzesModel({
    required this.azonosito,
    required this.emailCim,
    required this.megjegyzes,
    required this.datum,
    required this.felhasznaloNev
  });

  Map<String, dynamic> toJson() {
    return {
      'azonosito': azonosito,
      'emailCim': emailCim,
      'megjegyzes': megjegyzes,
      'datum': datum,
      'felhasznaloNev': felhasznaloNev,
    };
  }

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
