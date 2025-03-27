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

  // Firestore-ból történő lekéréshez (factory konstruktor)
  factory ElozmenyBejegyzesModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElozmenyBejegyzesModel(
      id: doc.id,
      email: data['email'] ?? '',
      idopont: (data['idopont'] as Timestamp).toDate(),
      nalaVan: data['nalaVan'] ?? false,
    );
  }

  // Firestore-ba mentéshez (Map-re alakítás)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'idopont': Timestamp.fromDate(idopont),
      'nalaVan': nalaVan,
    };
  }
}
