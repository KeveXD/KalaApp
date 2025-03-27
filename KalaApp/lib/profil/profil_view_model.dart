import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login/login_viewmodel.dart';
import '../models/eszkoz_model.dart';

class ProfilState {
  final String name;
  final String role;
  final bool hasDebt;
  final String? profilePictureUrl;
  final List<EszkozModel> jelenlegiEszkozok; // Felhasználó jelenlegi eszközei
  final List<EszkozModel> elozmenyEszkozok; // Felhasználó előzményei

  ProfilState({
    required this.name,
    required this.role,
    required this.hasDebt,
    this.profilePictureUrl,
    this.jelenlegiEszkozok = const [],
    this.elozmenyEszkozok = const [],
  });

  ProfilState copyWith({
    String? name,
    String? role,
    bool? hasDebt,
    String? profilePictureUrl,
    List<EszkozModel>? jelenlegiEszkozok,
    List<EszkozModel>? elozmenyEszkozok,
  }) {
    return ProfilState(
      name: name ?? this.name,
      role: role ?? this.role,
      hasDebt: hasDebt ?? this.hasDebt,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      jelenlegiEszkozok: jelenlegiEszkozok ?? this.jelenlegiEszkozok,
      elozmenyEszkozok: elozmenyEszkozok ?? this.elozmenyEszkozok,
    );
  }
}

class ProfilViewModel extends StateNotifier<ProfilState?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref ref;

  ProfilViewModel(this.ref) : super(null) {
    fetchProfilData();
  }

  Future<void> fetchProfilData() async {
    final loginState = ref.watch(loginViewModelProvider);
    final email = loginState.felhasznalo?.email;

    if (email == null) return;

    DocumentSnapshot userDoc = await _firestore.collection("Felhasznalok").doc(email).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;

      state = ProfilState(
        name: data["username"] ?? "Ismeretlen",
        role: data["role"] ?? "user",
        hasDebt: data["debt"] ?? false,
        profilePictureUrl: data["profilePicture"],
      );

      await fetchJelenlegiEszkozok(email);
      await fetchElozmenyEszkozok(email);
    }
  }

  /// **Lekéri a felhasználó jelenlegi eszközeit**
  Future<void> fetchJelenlegiEszkozok(String email) async {
    try {
      QuerySnapshot eszkozokSnapshot = await _firestore
          .collection("Eszkozok")
          .where("kinelVan", isEqualTo: email)
          .get();

      List<EszkozModel> eszkozok = eszkozokSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EszkozModel.fromJson(data);
      }).toList();

      state = state?.copyWith(jelenlegiEszkozok: eszkozok);
    } catch (e) {
      print("Hiba a jelenlegi eszközök lekérésekor: $e");
    }
  }

  /// **Lekéri a felhasználó előzményben szereplő eszközeit**
  Future<void> fetchElozmenyEszkozok(String email) async {
    try {
      QuerySnapshot eszkozokSnapshot = await _firestore.collection("Eszkozok").get();

      List<EszkozModel> elozmenyEszkozok = [];

      for (var doc in eszkozokSnapshot.docs) {
        bool szerepelElmultban = false;

        // Az adott eszköz előzményeinek lekérése az "elozmenyek" alkollekcióból
        QuerySnapshot elozmenyekSnapshot = await _firestore
            .collection("Eszkozok")
            .doc(doc.id)
            .collection("elozmenyek")
            .get();

        for (var elozmenyDoc in elozmenyekSnapshot.docs) {
          final elozmenyData = elozmenyDoc.data() as Map<String, dynamic>;
          if (elozmenyData['email'] == email) {
            szerepelElmultban = true;
            break; // Ha találtunk egy egyezést, nem kell tovább vizsgálni ezt az eszközt
          }
        }

        if (szerepelElmultban) {
          final data = doc.data() as Map<String, dynamic>;
          elozmenyEszkozok.add(EszkozModel.fromJson(data));
        }
      }

      state = state?.copyWith(elozmenyEszkozok: elozmenyEszkozok);
    } catch (e) {
      print("Hiba az előzmény eszközök lekérésekor: $e");
    }
  }

}

final profilViewModelProvider = StateNotifierProvider<ProfilViewModel, ProfilState?>((ref) {
  return ProfilViewModel(ref);
});
