class LeltarBejegyzesModel {
  final String id;
  final String felhasznaloAzonosito;
  final String datum;

  LeltarBejegyzesModel({
    required this.id,
    required this.felhasznaloAzonosito,
    required this.datum,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'felhasznaloAzonosito': felhasznaloAzonosito,
      'datum': datum,
    };
  }

  factory LeltarBejegyzesModel.fromJson(Map<String, dynamic> json) {
    return LeltarBejegyzesModel(
      id: json['id'] ?? '',
      felhasznaloAzonosito: json['felhasznaloAzonosito'] ?? '',
      datum: json['datum'] ?? '',
    );
  }
}
