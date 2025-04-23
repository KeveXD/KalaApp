import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/raktar_model.dart';
import '../models/eszkoz_model.dart';
import '../models/felhasznalo_model.dart';
import '../models/megjegyzes_model.dart';
import '../models/elozmeny_bejegyzes_model.dart';
import '../login/login_viewmodel.dart';
import '../services/eszkoz_firebase_services.dart';

class EszkozState {
  final List<EszkozModel> eszkozok;
  final List<RaktarModel> raktarak;
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
  final EszkozFirebaseService _firebaseService;

  EszkozViewModel(this._firebaseService) : super(EszkozState.initial()) {
    fetchRaktarak();
    fetchEszkozok();
  }

  Future<void> addNewEszkoz(EszkozModel ujEszkoz) async {
    try {
      await _firebaseService.addNewEszkoz(ujEszkoz);
      await fetchEszkozok();
    } catch (e) {
      print("Hiba az eszköz hozzáadása során: $e");
    }
  }

  Future<void> fetchRaktarak() async {
    try {
      state = state.copyWith(isLoading: true);

      final raktarak = await _firebaseService.fetchRaktarak();
      final raktarakNevei = raktarak.map((r) => r.nev).toList();

      state = state.copyWith(
          raktarak: raktarak, raktarakNevei: raktarakNevei, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: "Hiba a raktárak lekérdezésekor: $e");
    }
  }

  Future<void> fetchEszkozok() async {
    try {
      state = state.copyWith(isLoading: true);

      final eszkozok = await _firebaseService.fetchEszkozok();
      state = state.copyWith(eszkozok: eszkozok, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false,
          errorMessage: "Hiba az eszközök lekérdezésekor: $e");
    }
  }

  Future<int> getNextAvailableEszkozId() async {
    return await _firebaseService.getNextAvailableEszkozId();
  }

  Future<void> addMegjegyzesToEszkoz(EszkozModel eszkoz,
      MegjegyzesModel ujMegjegyzes) async {
    try {
      final updatedMegjegyzesek = List<MegjegyzesModel>.from(
          eszkoz.megjegyzesek)
        ..add(ujMegjegyzes);
      final updatedEszkoz = eszkoz.copyWith(megjegyzesek: updatedMegjegyzesek);

      await _firebaseService.updateEszkoz(eszkoz: updatedEszkoz);

      final updatedEszkozok = state.eszkozok.map((e) =>
      e.eszkozAzonosito == eszkoz.eszkozAzonosito ? updatedEszkoz : e
      ).toList();
      state = state.copyWith(eszkozok: updatedEszkozok);

      print("Megjegyzés sikeresen hozzáadva!");
    } catch (e) {
      print("Hiba a megjegyzés hozzáadásakor: $e");
    }
  }

  Future<MegjegyzesModel?> createMegjegyzes(String szoveg,
      WidgetRef ref) async {
    try {
      final aktualsiFelhasznalo = ref
          .read(loginViewModelProvider)
          .felhasznalo;
      if (aktualsiFelhasznalo == null) return null;

      String formattedDate = DateTime.now().toIso8601String();
      return MegjegyzesModel(
        azonosito: "11",
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

  Future<void> setKinelVanAzEszkoz(EszkozModel eszkoz, bool kinelVan,
      FelhasznaloModel? aktualisFelhasznalo) async {
    try {
      if (aktualisFelhasznalo == null) {
        print("Hiba: Nincs bejelentkezett felhasználó!");
        return;
      }

      final updatedEszkoz = eszkoz.copyWith(
        kinelVan: kinelVan ? aktualisFelhasznalo.email : '',
      );

      final elozmeny = ElozmenyBejegyzesModel(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        email: aktualisFelhasznalo.email,
        idopont: DateTime.now(),
        nalaVan: kinelVan,
      );

      await _firebaseService.updateEszkoz(
        eszkoz: updatedEszkoz,
      );
      await _firebaseService.addElozmenyBejegyzes(eszkoz, elozmeny);

      await fetchEszkozok(); // todo lehetne optimalisabb is

      print("Eszköz státusza sikeresen frissítve!");
    } catch (e) {
      print("Hiba az eszköz státuszának frissítésekor: $e");
    }
  }

  void updateEszkoz(EszkozModel regiEszkoz, EszkozModel ujEszkoz) async {
    try {
      if (regiEszkoz.eszkozAzonosito != ujEszkoz.eszkozAzonosito) {
        // Ha változott az azonosító, akkor töröljük a régit, és hozzáadjuk az újat
        await _firebaseService.deleteEszkoz(
            eszkozAzonosito: regiEszkoz.eszkozAzonosito);
        await _firebaseService.addNewEszkoz(ujEszkoz);
      } else {
        // Ha nem változott az azonosító, csak frissítjük
        await _firebaseService.updateEszkoz(eszkoz: ujEszkoz);
        fetchEszkozok();
        fetchRaktarak();
      }

      print("Eszköz sikeresen frissítve!");
    } catch (e) {
      print("Hiba az eszköz frissítésekor: $e");
    }
  }
}

  final eszkozViewModelProvider = StateNotifierProvider<EszkozViewModel, EszkozState>((ref) {
  final firebaseService = ref.read(eszkozFirebaseServiceProvider);
  return EszkozViewModel(firebaseService);
});
