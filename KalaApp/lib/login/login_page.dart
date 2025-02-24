import 'package:flutter/material.dart';
import 'package:kalaapp/login/register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bejelentkezés")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Felhasználónév"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Itt lehetne ellenőrizni a bejelentkezési adatokat
                print("Bejelentkezés: ${emailController.text}, ${usernameController.text}");
              },
              child: const Text("Bejelentkezés"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text("Nincs még fiókod? Regisztrálj itt!"),
            ),
          ],
        ),
      ),
    );
  }
}
