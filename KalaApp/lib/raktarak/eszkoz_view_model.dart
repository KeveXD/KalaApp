import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/models/raktar_model.dart';
import '../login/login_viewmodel.dart';
import '../models/elozmeny_bejegyzes_model.dart';
import '../models/eszkoz_model.dart';
import '../models/felhasznalo_model.dart';
import '../models/megjegyzes_model.dart';

class EszkozState {
  final List<EszkozModel> eszkozok;
  final List<RaktarModel> raktarak;//todo
  final List<String> raktarakNevei;
  final bool isLoading;
  final String? errorMessage;

  EszkozState({
    required this.eszkozok,
    required this.raktarakNevei,
    required this.raktarak,
    this.isLoading = false,
    this.errorMessage,
  });

  factory EszkozState.initial() {
    return EszkozState(
      eszkozok: [],
      raktarakNevei: [],
      raktarak: [],
    );
  }

  EszkozState copyWith({
    List<String>? raktarakNevei,
    List<EszkozModel>? eszkozok,
    List<RaktarModel>? raktarak,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EszkozState(
      raktarakNevei: raktarakNevei ?? this.raktarakNevei,
      raktarak: raktarak ?? this.raktarak,
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


  Future<void> addNewEszkoz(EszkozModel ujEszkoz) async {
    try {
      await _firestore.collection("Eszkozok").doc(ujEszkoz.eszkozAzonosito).set(ujEszkoz.toJson());

      // Újra lekérjük az eszközök listáját, hogy frissüljön az állapot
      await fetchEszkozok();
      print("Eszköz hozzáadva!");
    } catch (e) {
      print("Hiba az eszköz hozzáadása során: $e");
    }
  }

  Future<void> fetchRaktarak() async {
    try {
      state = state.copyWith(isLoading: true);

      final raktarakSnapshot = await _firestore.collection("Raktarak").get();

      List<RaktarModel> raktarak = raktarakSnapshot.docs.map((doc) {
        final data = doc.data();
        return RaktarModel(
          nev: doc.id,
          megjegyzes: data['megjegyzes'] ?? '',
          raktaronBelul: (data['raktaronBelul'] as List<dynamic>?)
              ?.whereType<int>()
              .toList(),
        );
      }).toList();

      List<String> raktarakNevei = raktarak.map((r) => r.nev).toList();

      state = state.copyWith(
        raktarak: raktarak,
        raktarakNevei: raktarakNevei,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Hiba a raktárak lekérdezésekor: $e",
      );
      print("Hiba a raktárak lekérdezésekor: $e");
    }
  }



  Future<void> fetchEszkozok() async
  {
    try {
      state = state.copyWith(isLoading: true);

      final eszkozokSnapshot = await _firestore.collection("Eszkozok").get();
      List<EszkozModel> eszkozok = eszkozokSnapshot.docs.map((doc) {
        return EszkozModel.fromJson(doc.data());
      }).toList();

      state = state.copyWith(eszkozok: eszkozok, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Hiba az eszközök lekérdezésekor: $e");
      print("Hiba az eszközök lekérdezésekor: $e");
    }
  }

  Future<int> getNextAvailableId() async {
    try {
      // Lekérdezzük az összes dokumentum azonosítóját
      final snapshot = await _firestore.collection("Eszkozok").get();

      // Kinyerjük az összes dokumentumnevet (azonosítót)
      Set<int> existingIds = snapshot.docs
          .map((doc) => int.tryParse(doc.id)) // Próbáljuk számmá alakítani az ID-ket
          .where((id) => id != null && id > 0) // Csak pozitív számokat tartunk meg
          .cast<int>()
          .toSet();

      // Megkeressük a legkisebb hiányzó természetes számot
      int newId = 1;
      while (existingIds.contains(newId)) {
        newId++;
      }

      return newId;
    } catch (e) {
      print("Hiba az azonosító keresése közben: $e");
      return -1; // Hiba esetén -1-et adunk vissza
    }
  }

  Future<void> addMegjegyzesToEszkoz(EszkozModel eszkoz, MegjegyzesModel ujMegjegyzes) async {
    try {
      // Új megjegyzések lista, amely tartalmazza az eddigieket + az újat
      List<MegjegyzesModel> updatedMegjegyzesek = List.from(eszkoz.megjegyzesek)..add(ujMegjegyzes);

      // Firestore-ban frissítjük az adott eszköz dokumentumát
      await _firestore.collection("Eszkozok").doc(eszkoz.eszkozAzonosito).update({
        'megjegyzesek': updatedMegjegyzesek.map((m) => m.toJson()).toList(),
      });

      // Frissítjük a helyi állapotot
      List<EszkozModel> updatedEszkozok = state.eszkozok.map((e) {
        return e.eszkozAzonosito == eszkoz.eszkozAzonosito
            ? e.copyWith(megjegyzesek: updatedMegjegyzesek)
            : e;
      }).toList();

      state = state.copyWith(eszkozok: updatedEszkozok);

      print("Megjegyzés sikeresen hozzáadva az eszközhöz!");
    } catch (e) {
      print("Hiba a megjegyzés hozzáadásakor: $e");
    }
  }

  Future<MegjegyzesModel?> createMegjegyzes(String szoveg, WidgetRef ref) async {
    try {
      // Bejelentkezett felhasználó lekérése a LoginViewModel-ből
      final aktualsiFelhasznalo = ref.read(loginViewModelProvider).felhasznalo;

      if (aktualsiFelhasznalo == null) {
        print("Hiba: Nincs bejelentkezett felhasználó!");
        return null;
      }

      // Aktuális dátum lekérése
      String formattedDate = DateTime.now().toIso8601String();

      // Megjegyzés létrehozása
      return MegjegyzesModel(
        azonosito: "11", // Fix azonosító
        megjegyzes: szoveg,
        datum: formattedDate,
        emailCim: aktualsiFelhasznalo.email,
        felhasznaloNev: aktualsiFelhasznalo.username,
      );
    } catch (e) {
      print("Hiba a megjegyzés létrehozásakor: $e");
      return null;
    }
  }

  Future<void> setKinelVanAzEszkoz(EszkozModel eszkoz, bool kinelVan, FelhasznaloModel? aktualisFelhasznalo) async {
    try {
      if (aktualisFelhasznalo == null) {
        print("Hiba: Nincs bejelentkezett felhasználó!");
        return;
      }

      // Frissítjük az adott eszköz "kinelVan" mezőjét Firestore-ban
      await _firestore.collection("Eszkozok").doc(eszkoz.eszkozAzonosito).update({
        'kinelVan': kinelVan
            ? aktualisFelhasznalo.email  // Ha kinelVan true, akkor beállítjuk az e-mail címet
            : '',
      });


      await addElozmenyBejegyzes(eszkoz, aktualisFelhasznalo.email, kinelVan);

      fetchEszkozok();


      print("Eszköz státusza sikeresen frissítve!");
    } catch (e) {
      print("Hiba az eszköz státuszának frissítésekor: $e");
    }
  }

  Future<void> addElozmenyBejegyzes(EszkozModel eszkoz, String email, bool kinelVan) async {
    try {
      final elozoBejegyzes = ElozmenyBejegyzesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Egyedi azonosító
        email: email,
        idopont: DateTime.now(),
        nalaVan: kinelVan,
      );

      await _firestore
          .collection("Eszkozok")
          .doc(eszkoz.eszkozAzonosito)
          .collection("elozmenyek") // Alkollekció az előzményeknek
          .doc(elozoBejegyzes.id) // Egyedi dokumentum ID
          .set(elozoBejegyzes.toMap());

      print("Előzmény sikeresen hozzáadva!");
    } catch (e) {
      print("Hiba az előzmény mentésekor: $e");
    }
  }


}

final eszkozViewModelProvider = StateNotifierProvider<EszkozViewModel, EszkozState>((ref) {
  return EszkozViewModel();
});
