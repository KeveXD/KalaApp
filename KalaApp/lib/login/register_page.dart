import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_viewmodel.dart';

import '../constants.dart';
import '../login_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  ElevatedButton(
                    onPressed: () {
                      // Regisztrációs logika a LoginViewModel-on keresztül
                      Provider.of<LoginViewModel>(context, listen: false).registerUser(
                        email: emailController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                        context: context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      "Regisztráció",
                      style: TextStyle(fontSize: 16, color: buttonTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
