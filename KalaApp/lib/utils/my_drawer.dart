import 'package:flutter/material.dart';
import '../constants.dart'; // Az új színpaletta importálása
import '../login/login_page.dart';

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
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.home, color: iconColor), // Ikon színe
              title: Text(
                'K E D V E N C E K',
                style: drawerTextColor, // A szöveg színe barna árnyalattal
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.settings, color: iconColor), // Ikon színe
              title: Text(
                'B E Á L L Í T Á S O K',
                style: drawerTextColor, // A szöveg színe barna árnyalattal
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.info, color: iconColor), // Ikon színe
              title: Text(
                'H A S Z N Á L A T',
                style: drawerTextColor, // A szöveg színe barna árnyalattal
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.logout, color: iconColor), // Ikon színe
              title: Text(
                'K I J E L E N T K E Z É S',
                style: drawerTextColor, // A szöveg színe barna árnyalattal
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // A kijelentkezés a bejelentkező oldalra navigál
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
