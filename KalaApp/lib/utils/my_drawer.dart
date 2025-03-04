import 'package:flutter/material.dart';
import '../constants.dart'; // Az új színpaletta importálása
import '../login/login_page.dart';
import '../raktarak/raktar_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cardBackgroundColor,
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.warehouse,
              size: 64,
              color: iconColor, // Az ikon színének beállítása a barna palettához
            ),
          ),
          _buildDrawerItem(Icons.person, "P R O F I L O M", context, () {
            // Ide jön a Profilom oldal navigációja
          }),
          _buildDrawerItem(Icons.inventory, "L E L T Á R", context, () {
            // Ide jön a Leltár oldal navigációja
          }),
          _buildDrawerItem(Icons.store, "R A K T Á R A K", context, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RaktarPage()), // Bejelentkező oldalra navigál
            );
          }),
          _buildDrawerItem(Icons.chat, "C H A T", context, () {
            // Ide jön a Chat oldal navigációja
          }),
          _buildDrawerItem(Icons.feedback, "V I S S Z A J E L Z É S", context, () {
            // Ide jön a Visszajelzés oldal navigációja
          }),
          const Divider(), // Elválasztó vonal a kijelentkezés előtt
          _buildDrawerItem(Icons.home, "K E D V E N C E K", context, () {}),
          _buildDrawerItem(Icons.settings, "B E Á L L Í T Á S O K", context, () {}),
          _buildDrawerItem(Icons.info, "H A S Z N Á L A T", context, () {}),
          _buildDrawerItem(Icons.logout, "K I J E L E N T K E Z É S", context, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), // Bejelentkező oldalra navigál
            );
          }),
        ],
      ),
    );
  }

  /// Egy segédfüggvény a Drawer menüpontok egyszerűsítésére
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: tilePadding,
      child: ListTile(
        leading: Icon(icon, color: iconColor), // Ikon
        title: Text(
          title,
          style: drawerTextColor, // Szöveg stílusa
        ),
        onTap: onTap,
      ),
    );
  }
}
