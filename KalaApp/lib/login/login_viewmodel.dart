import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../menu_page/menu_desktop.dart';
import '../../menu_page/menu_mobil.dart';
import '../../menu_page/menu_tablet.dart';
import '../../utils/responsive_layout.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String? email;
  final String? password;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.email,
    this.password,
  });
}

class LoginViewModel extends StateNotifier<LoginState> {
  static final LoginViewModel _instance = LoginViewModel._internal();
  factory LoginViewModel() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _email;
  String? _password;

  LoginViewModel._internal() : super(LoginState());

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async
  {
    state = LoginState(isLoading: true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _email = email;
      _password = password;

      // Ellenőrizzük, hogy van-e már ilyen felhasználó a Firestore-ban
      DocumentReference userDoc = _firestore.collection("Felhasznalok").doc(email);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Ha a dokumentum nem létezik, nem csinálunk semmit, mert a dokumentum létrehozása a regisztrációnál történik
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ez a felhasználó nem létezik a rendszerben.")),
        );
        return;
      }

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

      state = LoginState(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      state = LoginState(errorMessage: e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hiba: \${e.message}")),
      );
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    String? profilePictureUrl, // Ez a profilkép URL-je lesz
    required Function(String message) showSnackBar,
  }) async {
    if (password != confirmPassword) {
      showSnackBar("A jelszavak nem egyeznek!");
      return;
    }

    state = LoginState(isLoading: true);

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Dokumentum létrehozása a "Felhasznalok" kollekcióban
      DocumentReference userDoc = _firestore.collection("Felhasznalok").doc(email);
      await userDoc.set({
        "email": email,
        "username": username,
        "password": password, // Biztonsági okokból nem ajánlott a jelszót tárolni, csak bemutató célra
        "role": "user",
        "debt": false,
        "profilePicture": profilePictureUrl, // A profilkép URL-je
      });

      showSnackBar("Sikeres regisztráció!");
      state = LoginState();
    } on FirebaseAuthException catch (e) {
      state = LoginState(errorMessage: e.message);
      showSnackBar("Hiba: \${e.message}");
    }
  }

  String? get email => _email;
  String? get password => _password;
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});
