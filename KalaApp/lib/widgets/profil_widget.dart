import 'package:flutter/material.dart';
import '../constants.dart'; // Színpaletta importálása

class ProfilWidget extends StatelessWidget {
  final String name;
  final String role;
  final bool hasDebt;

  const ProfilWidget({
    Key? key,
    required this.name,
    required this.role,
    required this.hasDebt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity, // Ez biztosítja, hogy mindig kitöltse a szélességet
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardBackgroundColor, // Lista háttérszíne
          boxShadow: [
            BoxShadow(
              color: cardShadowColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 50, color: iconColor), // Profil ikon
              const SizedBox(height: 10),
              Text(name, style: drawerTextColor),
              Text(role, style: drawerTextColor),
              const SizedBox(height: 10),
              Text(
                hasDebt ? "Tartozás van!" : "Nincs tartozás",
                style: TextStyle(fontSize: 14, color: hasDebt ? Colors.red : Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
