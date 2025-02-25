import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Regisztrálás metódus
  Future<void> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    if (password != confirmPassword) {
      // Jelszavak nem egyeznek, hibaüzenet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A jelszavak nem egyeznek!")),
      );
      return;
    }

    try {
      // Regisztráció Firebase Authentication segítségével
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ha sikeres, átirányíthatjuk a felhasználót a bejelentkezett képernyőre
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sikeres regisztráció!")),
      );
      // Lehetőség van itt további navigációra, pl. `Navigator.pushReplacement()`
    } on FirebaseAuthException catch (e) {
      // Hiba esetén, Firebase hibák kezelése
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hiba: ${e.message}")),
      );
    }
  }
}
