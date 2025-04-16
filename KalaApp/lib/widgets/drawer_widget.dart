import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/szervezoi/beallitasok/szervezoi_beallitasok_page.dart';
import 'package:kalaapp/utils/responsive_layout.dart';
import '../constants.dart';
import '../leltar/leltar_page.dart';
import '../login/login_viewmodel.dart';
import '../login/login_page.dart';
import '../menu_page/menu_desktop.dart';
import '../menu_page/menu_mobil.dart';
import '../menu_page/menu_tablet.dart';
import '../profil/profil_page.dart';
import '../raktarak/eszkozok_page.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final felhasznalo = ref.watch(loginViewModelProvider).felhasznalo;

    return Drawer(
      backgroundColor: cardBackgroundColor,
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.warehouse,
              size: 64,
              color: iconColor,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(Icons.person, "P R O F I L O M", context, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilPage()),
                    );
                  }),



                  _buildDrawerItem(Icons.store, "E S Z K Ö Z Ö K", context, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EszkozokPage()),
                    );
                  }),

                  _buildDrawerItem(Icons.feedback, "V I S S Z A J E L Z É S", context, () {}),

                  // Csak akkor jelenjen meg, ha a felhasználó "szervezo" szerepkörű
                  if (felhasznalo != null && felhasznalo.role == "szervezo")
                    Padding(
                      padding: tilePadding,
                      child: ExpansionTile(
                        leading: Icon(Icons.admin_panel_settings, color: iconColor),
                        title: Text("S Z E R V E Z Ő I", style: drawerTextColor),
                        children: [
                          _buildDrawerItem(Icons.inventory, "L E L T Á R", context, () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LeltarPage()),
                            );

                          }),
                          _buildDrawerItem(Icons.verified_user, "J O G O S U L T S Á G O K", context, () {}),
                          _buildDrawerItem(Icons.settings_applications, "B E Á L L Í T Á S O K", context, () {Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SzervezoiBeallitasokPage()),
                          );}),
                        ],
                      ),
                    ),

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

  /// Segédfüggvény a Drawer menüpontok egyszerűsítésére
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: drawerTextColor),
      onTap: onTap,
    );
  }
}
