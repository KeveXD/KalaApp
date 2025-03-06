import 'package:flutter/material.dart';
import 'package:kalaapp/utils/responsive_layout.dart';
import '../constants.dart'; // Az új színpaletta importálása
import '../login/login_page.dart';
import '../menu_page/menu_desktop.dart';
import '../menu_page/menu_mobil.dart';
import '../menu_page/menu_tablet.dart';
import '../raktarak/raktar_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(Icons.person, "P R O F I L O M", context, () {}),
                  _buildDrawerItem(Icons.inventory, "L E L T Á R", context, () {}),
                  _buildDrawerItem(Icons.store, "R A K T Á R A K", context, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RaktarPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.chat, "C H A T", context, () {}),
                  _buildDrawerItem(Icons.feedback, "V I S S Z A J E L Z É S", context, () {}),
                  const Divider(),
                  _buildDrawerItem(Icons.home, "K E D V E N C E K", context, () {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ResponsiveLayout(
                        mobileBody: const MenuMobil(),
                        tabletBody: const MenuTablet(),
                        desktopBody: const MenuDesktop(),
                      )),
                    );
                  }),
                  _buildDrawerItem(Icons.settings, "B E Á L L Í T Á S O K", context, () {}),
                  _buildDrawerItem(Icons.info, "H A S Z N Á L A T", context, () {}),
                  _buildDrawerItem(Icons.logout, "K I J E L E N T K E Z É S", context, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Egy segédfüggvény a Drawer menüpontok egyszerűsítésére
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: tilePadding,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: drawerTextColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
