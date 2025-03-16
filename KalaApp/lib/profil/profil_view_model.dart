import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login/login_viewmodel.dart';

class ProfilState {
  final String name;
  final String role;
  final bool hasDebt;
  final String? profilePictureUrl;

  ProfilState({
    required this.name,
    required this.role,
    required this.hasDebt,
    this.profilePictureUrl,
  });
}

class ProfilViewModel extends StateNotifier<ProfilState?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Ref ref;

  ProfilViewModel(this.ref) : super(null) {
    fetchProfilData();
  }

  Future<void> fetchProfilData() async {
    final loginState = ref.watch(loginViewModelProvider); // Elérjük a LoginViewModel státuszt
    final email = loginState.email;

    if (email == null) return; // Ha nincs bejelentkezve, nem tudunk adatokat kérni

    DocumentSnapshot userDoc = await _firestore.collection("Felhasznalok").doc(email).get();
    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      state = ProfilState(
        name: data["username"] ?? "Ismeretlen",
        role: data["role"] ?? "user",
        hasDebt: data["debt"] ?? false,
        profilePictureUrl: data["profilePicture"],  // Profilkép URL
      );
    }
  }
}

final profilViewModelProvider = StateNotifierProvider<ProfilViewModel, ProfilState?>((ref) {
  return ProfilViewModel(ref);
});
