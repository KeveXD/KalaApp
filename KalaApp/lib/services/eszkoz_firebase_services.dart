import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eszkoz_model.dart';
import '../models/elozmeny_bejegyzes_model.dart';
import '../models/leltar_bejegyzes_model.dart';
import '../models/megjegyzes_model.dart';
import '../models/raktar_model.dart';

class EszkozFirebaseService {
  final FirebaseFirestore _firestore;

  EszkozFirebaseService(this._firestore);

  Future<void> addNewEszkoz(EszkozModel ujEszkoz) async {
    final eszkozRef = _firestore.collection("Eszkozok").doc(ujEszkoz.eszkozAzonosito);

    // Alap eszköz feltöltése
    await eszkozRef.set(ujEszkoz.toJson());

    // Előzmények feltöltése
    final elozmenyekRef = eszkozRef.collection("Elozmenyek");
    for (final elozmeny in ujEszkoz.elozmenyek) {
      await elozmenyekRef.doc(elozmeny.id).set(elozmeny.toMap());
    }

    // Leltározások feltöltése
    final leltarozasokRef = eszkozRef.collection("Leltarozasok");
    for (final leltar in ujEszkoz.leltarozasok) {
      await leltarozasokRef.doc(leltar.id).set(leltar.toJson());
    }

    // Megjegyzések feltöltése
    final megjegyzesekRef = eszkozRef.collection("Megjegyzesek");
    for (final megjegyzes in ujEszkoz.megjegyzesek) {
      await megjegyzesekRef.doc(megjegyzes.azonosito).set(megjegyzes.toJson());
    }
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

  ///minden eszkozhoz tartozo kollekcio-t is letolt
  Future<List<EszkozModel>> fetchEszkozok() async {
    final eszkozokSnapshot = await _firestore.collection("Eszkozok").get();

    List<EszkozModel> eszkozok = [];

    for (final doc in eszkozokSnapshot.docs) {
      final baseEszkoz = EszkozModel.fromJson(doc.data());

      final docRef = _firestore.collection("Eszkozok").doc(doc.id);

      // Lekérjük az elozmenyek alkollekciót
      final elozmenyekSnapshot = await docRef.collection("Elozmenyek").get();
      final elozmenyek = elozmenyekSnapshot.docs
          .map((e) => ElozmenyBejegyzesModel.fromFirestore(e))
          .toList();

      // Lekérjük a megjegyzesek alkollekciót
      final megjegyzesekSnapshot = await docRef.collection("Megjegyzesek").get();
      final megjegyzesek = megjegyzesekSnapshot.docs
          .map((m) => MegjegyzesModel.fromJson(m.data()))
          .toList();

      // Lekérjük a leltarozasok alkollekciót
      final leltarozasokSnapshot = await docRef.collection("Leltarozasok").get();
      final leltarozasok = leltarozasokSnapshot.docs
          .map((l) => LeltarBejegyzesModel.fromJson(l.data()))
          .toList();

      // Új példány a listákkal
      final teljesEszkoz = baseEszkoz.copyWith(
        elozmenyek: elozmenyek,
        megjegyzesek: megjegyzesek,
        leltarozasok: leltarozasok,
      );

      eszkozok.add(teljesEszkoz);
    }

    return eszkozok;
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

  ///kulon collection az "Eszkozok"-on belul
  Future<void> addElozmenyBejegyzes(EszkozModel eszkoz, ElozmenyBejegyzesModel elozoBejegyzes) async {
    await _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("Elozmenyek")
        .doc(elozoBejegyzes.id)
        .set(elozoBejegyzes.toMap());
  }

  ///kulon collection az "Eszkozok"-on belul
  Future<void> addLeltarBejegyzes(EszkozModel eszkoz, LeltarBejegyzesModel bejegyzes) async {
    await _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("Leltarozasok")
        .doc(bejegyzes.id)
        .set(bejegyzes.toJson());
  }

  ///kulon collection az "Eszkozok"-on belul
  Future<void> addMegjegyzesBejegyzes(EszkozModel eszkoz, MegjegyzesModel megjegyzes) async {
    await _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("Megjegyzesek")
        .doc(megjegyzes.azonosito)
        .set(megjegyzes.toJson());
  }

  ///nem hiv letoltest csak firestoreban frissit
  Future<void> updateElozmenyekForEszkoz(EszkozModel eszkoz) async {
    final elozmenyekRef = _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("elozmenyek");

    final snapshot = await elozmenyekRef.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    for (final bejegyzes in eszkoz.elozmenyek) {
      await elozmenyekRef.doc(bejegyzes.id).set(bejegyzes.toMap());
    }
  }

  ///nem hiv letoltest csak firestoreban frissit
  Future<void> updateLeltarozasokForEszkoz(EszkozModel eszkoz) async {
    final leltarRef = _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("Leltarozasok");

    final snapshot = await leltarRef.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    for (final leltar in eszkoz.leltarozasok) {
      await leltarRef.doc(leltar.id).set(leltar.toJson());
    }
  }

  ///nem hiv letoltest csak firestoreban frissit
  Future<void> updateMegjegyzesekForEszkoz(EszkozModel eszkoz) async {
    final megjegyzesekRef = _firestore
        .collection("Eszkozok")
        .doc(eszkoz.eszkozAzonosito)
        .collection("Megjegyzesek");

    final snapshot = await megjegyzesekRef.get();

    //
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

    for (final megjegyzes in eszkoz.megjegyzesek) {
      await megjegyzesekRef.doc(megjegyzes.azonosito).set(megjegyzes.toJson());
    }
  }



  ///az elozmenyek" "leltarozasok" "megjegyzesek" kollekciok nem frissulnek az eszkozUpdate-nel
  Future<void> updateEszkoz({
    required EszkozModel eszkoz,
  }) async {
    final eszkozRef = _firestore.collection("Eszkozok").doc(eszkoz.eszkozAzonosito);

    await eszkozRef.update(eszkoz.toJson());
  }


  Future<void> deleteEszkoz({
    required String eszkozAzonosito,
  }) async {
    final eszkozRef = _firestore.collection("Eszkozok").doc(eszkozAzonosito);

    await eszkozRef.delete();
  }

}




final eszkozFirebaseServiceProvider = Provider<EszkozFirebaseService>((ref) {
  return EszkozFirebaseService(FirebaseFirestore.instance);
});