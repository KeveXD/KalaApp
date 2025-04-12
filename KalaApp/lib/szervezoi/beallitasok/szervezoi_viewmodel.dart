import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/raktar_model.dart';

final szervezoiViewModelProvider =
StateNotifierProvider<SzervezoiViewModel, List<int>>((ref) {
  return SzervezoiViewModel();
});

class SzervezoiViewModel extends StateNotifier<List<int>> {
  SzervezoiViewModel() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addResz(int resz) {
    state = [...state, resz];
  }

  void removeResz(int index) {
    state = [...state]..removeAt(index);
  }

  Future<void> addRaktar(String nev, String? megjegyzes) async {
    if (nev.isEmpty) return;

    final raktar = RaktarModel(
      nev: nev,
      megjegyzes: megjegyzes,
      raktaronBelul: state,
    );

    try {
      await _firestore.collection("Raktarak").doc(raktar.nev).set({
        "nev": raktar.nev,
        "megjegyzes": raktar.megjegyzes ?? "",
        "raktaronBelul": raktar.raktaronBelul, // Most már a teljes lista
      });

      state = []; // Raktár hozzáadása után reseteljük a listát
    } catch (e) {
      print("Hiba történt a raktár mentésekor: $e");
    }
  }
}
