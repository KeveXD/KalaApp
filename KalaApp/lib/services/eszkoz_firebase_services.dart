import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eszkoz_model.dart';
import '../models/elozmeny_bejegyzes_model.dart';
import '../models/raktar_model.dart';

class EszkozFirebaseService {
  final FirebaseFirestore _firestore;

  EszkozFirebaseService(this._firestore);

  Future<void> addNewEszkoz(EszkozModel ujEszkoz) async {
    await _firestore.collection("Eszkozok").doc(ujEszkoz.eszkozAzonosito).set(ujEszkoz.toJson());
  }

  Future<List<RaktarModel>> fetchRaktarak() async {
    final raktarakSnapshot = await _firestore.collection("Raktarak").get();
    return raktarakSnapshot.docs.map((doc) {
      final data = doc.data();
      return RaktarModel(
        nev: doc.id,
        megjegyzes: data['megjegyzes'] ?? '',
        raktaronBelul: (data['raktaronBelul'] as List<dynamic>?)?.whereType<int>().toList(),
      );
    }).toList();
  }

  Future<List<EszkozModel>> fetchEszkozok() async {
    final eszkozokSnapshot = await _firestore.collection("Eszkozok").get();
    return eszkozokSnapshot.docs.map((doc) => EszkozModel.fromJson(doc.data())).toList();
  }

  Future<int> getNextAvailableEszkozId() async {
    final snapshot = await _firestore.collection("Eszkozok").get();
    Set<int> existingIds = snapshot.docs
        .map((doc) => int.tryParse(doc.id))
        .where((id) => id != null && id > 0)
        .cast<int>()
        .toSet();

    int newId = 1;
    while (existingIds.contains(newId)) {
      newId++;
    }
    return newId;
  }

  //lehetne hasznalni
  Future<void> addElozmenyBejegyzes(EszkozModel eszkoz, ElozmenyBejegyzesModel elozoBejegyzes) async {
    await _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("elozmenyek")
        .doc(elozoBejegyzes.id)
        .set(elozoBejegyzes.toMap());
  }

  Future<void> updateEszkoz({
    required EszkozModel eszkoz,
    ElozmenyBejegyzesModel? elozmeny,
  }) async {
    final eszkozRef = _firestore.collection("Eszkozok").doc(eszkoz.eszkozAzonosito);

    await eszkozRef.update(eszkoz.toJson());

    if (elozmeny != null) {
      await eszkozRef
          .collection("elozmenyek")
          .doc(elozmeny.id)
          .set(elozmeny.toMap());
    }
  }
}


final eszkozFirebaseServiceProvider = Provider<EszkozFirebaseService>((ref) {
  return EszkozFirebaseService(FirebaseFirestore.instance);
});