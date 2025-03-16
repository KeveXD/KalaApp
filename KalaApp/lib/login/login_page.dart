import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../login/register_page.dart';
import 'login_viewmodel.dart';
import '../widgets/drawer_widget.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider); // Figyeljük az állapotot

    return Scaffold(
      backgroundColor: defaultBackgroundColor, // Szín a háttérhez
      appBar: AppBar(
        backgroundColor: appBarColor, // AppBar színe
        title: Text("Bejelentkezés", style: TextStyle(color: primaryTextColor)), // Cím szövege
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor), // Ikonok színe
      ),
      drawer: const DrawerWidget(), // Oldalsó menü (Drawer)
      body: Center(
        child: Padding(
          padding: tilePadding, // Padding beállítás
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            color: cardBackgroundColor, // Kártya háttérszíne
            shadowColor: cardShadowColor, // Kártya árnyéka
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)), // Szegély színe
                      filled: true,
                      fillColor: inputFieldColor, // Bemeneti mező háttérszíne
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Jelszó",
                      border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)), // Szegély színe
                      filled: true,
                      fillColor: inputFieldColor, // Bemeneti mező háttérszíne
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
                      backgroundColor: buttonColor, // Gomb háttérszíne
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: loginState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Bejelentkezés",
                            style: TextStyle(fontSize: 16, color: buttonTextColor), // Gomb szövege
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
                      style: TextStyle(fontSize: 14, color: buttonColor), // Szöveg színe
                    ),
                  ),
                  if (loginState.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      loginState.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), // Hibaüzenet
                    ),
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
