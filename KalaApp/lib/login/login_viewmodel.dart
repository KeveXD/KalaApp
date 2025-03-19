import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../menu_page/menu_desktop.dart';
import '../../menu_page/menu_mobil.dart';
import '../../menu_page/menu_tablet.dart';
import '../../models/felhasznalo_model.dart'; // FelhasznaloModel importálása
import '../../utils/responsive_layout.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final FelhasznaloModel? felhasznalo; // Most már az egész felhasználói modellt tároljuk

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.felhasznalo,
  });
}

class LoginViewModel extends StateNotifier<LoginState> {
  static final LoginViewModel _instance = LoginViewModel._internal();
  factory LoginViewModel() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginViewModel._internal() : super(LoginState());

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = LoginState(isLoading: true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Felhasználói adatok lekérése Firestore-ból
      DocumentReference userDoc = _firestore.collection("Felhasznalok").doc(email);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ez a felhasználó nem létezik a rendszerben.")),
        );
        state = LoginState(errorMessage: "Felhasználó nem található");
        return;
      }

      // Felhasználó betöltése a Firestore-ból FelhasznaloModel-ként
      FelhasznaloModel felhasznalo = FelhasznaloModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

      // Beállítjuk a state-et a bejelentkezett felhasználóval
      state = LoginState(felhasznalo: felhasznalo);

      // Navigáció a főoldalra
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileBody: const MenuMobil(),
            tabletBody: const MenuTablet(),
            desktopBody: const MenuDesktop(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      state = LoginState(errorMessage: e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hiba: ${e.message}")),
      );
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    String? profilePictureUrl,
    required Function(String message) showSnackBar,
  }) async {
    if (password != confirmPassword) {
      showSnackBar("A jelszavak nem egyeznek!");
      return;
    }

    state = LoginState(isLoading: true);

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Új felhasználó létrehozása FelhasznaloModel-ként
      FelhasznaloModel newUser = FelhasznaloModel(
        username: username,
        email: email,
        role: "user",
        debt: false,
        profilePicture: profilePictureUrl, password: '',
      );

      // Firestore mentés
      await _firestore.collection("Felhasznalok").doc(email).set(newUser.toJson());

      showSnackBar("Sikeres regisztráció!");
      state = LoginState();
    } on FirebaseAuthException catch (e) {
      state = LoginState(errorMessage: e.message);
      showSnackBar("Hiba: ${e.message}");
    }
  }

  FelhasznaloModel? get felhasznalo => state.felhasznalo;
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
