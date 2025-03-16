import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../constants.dart';
import 'login_viewmodel.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? profilePicture;

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
                  // Felhasználónév
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Felhasználónév*",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail*",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  // Jelszó
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Jelszó*",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Jelszó megerősítése
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Jelszó megerősítése*",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
                      filled: true,
                      fillColor: inputFieldColor,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Profilkép feltöltés
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        profilePicture = result.files.single.path;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: inputFieldColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: inputBorderColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt, color: iconColor),
                          const SizedBox(width: 10),
                          Text(
                            profilePicture != null ? 'Profilkép kiválasztva' : 'Profilkép feltöltése',
                            style: TextStyle(color: profilePicture != null ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Regisztráció gomb
                  ElevatedButton(
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                      if (usernameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Minden kötelező mezőt ki kell tölteni!')),
                        );
                        return;
                      }

                      ref.read(loginViewModelProvider.notifier).registerUser(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                       // profilePicture: profilePicture,
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
