import 'package:cloud_firestore/cloud_firestore.dart';

class ElozmenyBejegyzesModel {
  final String id; // Egyedi azonosító
  final String email; // Felhasználó e-mail címe
  final DateTime idopont; // Mikor történt az esemény
  final bool nalaVan; // Elvitte-e vagy visszahozta-e

  ElozmenyBejegyzesModel({
    required this.id,
    required this.email,
    required this.idopont,
    required this.nalaVan,
  });

  /// Firestore dokumentumból példányosítás
  factory ElozmenyBejegyzesModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElozmenyBejegyzesModel(
      id: doc.id,
      email: data['email'] ?? '',
      idopont: (data['idopont'] as Timestamp).toDate(),
      nalaVan: data['nalaVan'] ?? false,
    );
  }

  /// Átalakítás JSON formátumú map-re (Firestore mentéshez is jó)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'idopont': Timestamp.fromDate(idopont),
      'nalaVan': nalaVan,
    };
  }

  /// Átalakítás JSON-ból (pl. Firebase REST API vagy sima map alapján)
  factory ElozmenyBejegyzesModel.fromMap(Map<String, dynamic> map) {
    return ElozmenyBejegyzesModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      idopont: (map['idopont'] is Timestamp)
          ? (map['idopont'] as Timestamp).toDate()
          : DateTime.tryParse(map['idopont'] ?? '') ?? DateTime.now(),
      nalaVan: map['nalaVan'] ?? false,
    );
  }

  /// JSON kompatibilis formátum (string típusú dátummal, ha kell pl. loghoz)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'idopont': idopont.toIso8601String(),
      'nalaVan': nalaVan,
    };
  }

  /// Másolat készítése módosított értékekkel
  ElozmenyBejegyzesModel copyWith({
    String? id,
    String? email,
    DateTime? idopont,
    bool? nalaVan,
  }) {
    return ElozmenyBejegyzesModel(
      id: id ?? this.id,
      email: email ?? this.email,
      idopont: idopont ?? this.idopont,
      nalaVan: nalaVan ?? this.nalaVan,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ElozmenyBejegyzesModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              email == other.email &&
              idopont == other.idopont &&
              nalaVan == other.nalaVan;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ idopont.hashCode ^ nalaVan.hashCode;
}
