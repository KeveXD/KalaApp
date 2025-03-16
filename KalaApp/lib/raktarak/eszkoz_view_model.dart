import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eszkoz_model.dart';

class EszkozState {
  final List<EszkozModel> eszkozok;  // Eszközök listája EszkozModel típusban
  final List<String> raktarakNevei;  // A raktárak nevei (ID-k)
  final bool isLoading;              // Betöltési állapot
  final String? errorMessage;        // Hibaüzenet

  EszkozState({
    required this.eszkozok,
    required this.raktarakNevei,
    this.isLoading = false,
    this.errorMessage,
  });

  // Az alapértelmezett állapot, amikor még nincsenek raktárak lekérve
  factory EszkozState.initial() {
    return EszkozState(
      eszkozok: [],                // Eszközök alapértelmezett üres listája
      raktarakNevei: [],           // Raktárak neveinek alapértelmezett üres listája
    );
  }

  // Új állapot esetén nem kell teljesen új állapot, hanem a meglévőt másoljuk és módosítjuk
  EszkozState copyWith({
    List<String>? raktarakNevei,
    List<EszkozModel>? eszkozok,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EszkozState(
      raktarakNevei: raktarakNevei ?? this.raktarakNevei,
      eszkozok: eszkozok ?? this.eszkozok,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EszkozViewModel extends StateNotifier<EszkozState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EszkozViewModel() : super(EszkozState.initial()) {
    fetchRaktarak();
    fetchEszkozok();
  }

  // Lekérdezi a "Raktarak" kollekció összes dokumentum nevét
  Future<void> fetchRaktarak() async {
    try {
      state = state.copyWith(isLoading: true);  // Betöltési állapot

      final raktarakSnapshot = await _firestore.collection("Raktarak").get();
      List<String> raktarakNevei = raktarakSnapshot.docs
          .map((doc) => doc.id) // Dokumentum nevei (ID-k) lesznek a raktárak
          .toList();

      state = state.copyWith(raktarakNevei: raktarakNevei, isLoading: false);  // Állapot frissítése
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Hiba a raktárak lekérdezésekor: $e");
      print("Hiba a raktárak lekérdezésekor: $e");
    }
  }

  // Új eszköz hozzáadása a "Eszkozok" kollekcióhoz
  Future<void> addNewEszkoz({
    required String eszkozAzonosito,
    required String eszkozNev,
    required String location,
    required String felelosNev,
    required String comment,
  }) async {
    try {
      await _firestore.collection("Eszkozok").doc(eszkozAzonosito).set({
        "eszkozNev": eszkozNev,
        "eszkozAzonosito": eszkozAzonosito,
        "location": location,
        "felelosNev": felelosNev,
        "comment": comment,
        "timestamp": FieldValue.serverTimestamp(),
      });
      print("Eszköz hozzáadva!");
    } catch (e) {
      print("Hiba az eszköz hozzáadása során: $e");
    }
  }

  // Lekérdezi az "Eszkozok" kollekció összes eszközeit
  Future<void> fetchEszkozok() async {
    print("LOOOOL");
    try {
      state = state.copyWith(isLoading: true);  // Betöltési állapot

      final eszkozokSnapshot = await _firestore.collection("Eszkozok").get();
      List<EszkozModel> eszkozok = eszkozokSnapshot.docs.map((doc) {
        return EszkozModel.fromJson(doc.data());
      }).toList();

      state = state.copyWith(eszkozok: eszkozok, isLoading: false);  // Állapot frissítése
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Hiba az eszközök lekérdezésekor: $e");
      print("Hiba az eszközök lekérdezésekor: $e");
    }
  }
}

final eszkozViewModelProvider = StateNotifierProvider<EszkozViewModel, EszkozState>((ref) {
  return EszkozViewModel();
});




