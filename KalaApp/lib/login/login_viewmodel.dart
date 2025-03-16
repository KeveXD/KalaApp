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
    required Function(String message) showSnackBar,
  }) async
  {
    if (password != confirmPassword) {
      showSnackBar("A jelszavak nem egyeznek!");
      return;
    }

    state = LoginState(isLoading: true);

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
