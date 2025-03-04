import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../login/register_page.dart';
import '../login_viewmodel.dart';
import '../utils/my_drawer.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider); // Figyeljük az állapotot

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Bejelentkezés", style: TextStyle(color: primaryTextColor)),
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
      ),
      drawer: const MyDrawer(),
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
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loginState.isLoading
                        ? null
                        : () {
                      ref.read(loginViewModelProvider.notifier).loginUser(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: loginState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Bejelentkezés",
                      style: TextStyle(fontSize: 16, color: buttonTextColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Nincs még fiókod? Regisztrálj itt!",
                      style: TextStyle(fontSize: 14, color: buttonColor),
                    ),
                  ),
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
