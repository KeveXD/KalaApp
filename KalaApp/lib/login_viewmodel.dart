import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu_page/menu_desktop.dart';
import '../menu_page/menu_mobil.dart';
import '../menu_page/menu_tablet.dart';
import '../utils/responsive_layout.dart';

// Állapotmodell a loginhoz
class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({this.isLoading = false, this.errorMessage});
}

// ViewModel (StateNotifier) - Riverpod
class LoginViewModel extends StateNotifier<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginViewModel() : super(LoginState());

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = LoginState(isLoading: true); // Betöltés indítása

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Ha sikeres, navigálás a menüre
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

      state = LoginState(); // Sikeres állapot
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
    required Function(String message) showSnackBar,
  }) async {
    if (password != confirmPassword) {
      showSnackBar("A jelszavak nem egyeznek!");
      return;
    }

    state = LoginState(isLoading: true); // Betöltés indítása

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      showSnackBar("Sikeres regisztráció!");
      state = LoginState(); // Sikeres állapot
    } on FirebaseAuthException catch (e) {
      state = LoginState(errorMessage: e.message);
      showSnackBar("Hiba: ${e.message}");
    }
  }













}

// Riverpod provider
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
