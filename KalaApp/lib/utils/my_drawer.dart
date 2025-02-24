import 'package:flutter/material.dart';

import '../constants.dart';
import '../login/login_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      elevation: 0,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.favorite,
              size: 64,
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'K E D V E N C E K',
                style: drawerTextColor,
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'B E Á L L Í T Á S O K',
                style: drawerTextColor,
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'H A S Z N Á L A T',
                style: drawerTextColor,
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'K I J E L E N T K E Z É S',
                style: drawerTextColor,
              ),
              onTap: () {
                // Visszavisz a bejelentkezési képernyőre kijelentkezéskor
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// FŐKÉPERNYŐ (HOME)
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Főoldal'),
      ),
      drawer: const MyDrawer(),
      body: const Center(
        child: Text("Üdv a főoldalon!"),
      ),
    );
  }
}
