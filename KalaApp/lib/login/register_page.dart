import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../login_viewmodel.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider); // Figyeljük az állapotot

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Regisztráció", style: TextStyle(color: primaryTextColor)),
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            color: cardBackgroundColor,
            shadowColor: cardShadowColor,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Jelszó",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Jelszó megerősítése",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Regisztráció gomb
                  ElevatedButton(
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                      ref.read(loginViewModelProvider.notifier).registerUser(
                        email: emailController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                        showSnackBar: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: loginState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Regisztráció",
                      style: TextStyle(fontSize: 16, color: buttonTextColor),
                    ),
                  ),

                  // Hibaüzenet kijelzése
                  if (loginState.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(loginState.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
