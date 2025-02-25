import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ne felejtsd el importálni a provider-t
import 'login_viewmodel.dart';

import 'menu_page/menu_desktop.dart';
import 'menu_page/menu_mobil.dart';
import 'menu_page/menu_tablet.dart';
import 'utils/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase inicializálása
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(), // A LoginViewModel provider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: ResponsiveLayout(
          mobileBody: const MenuMobil(),
          tabletBody: const MenuTablet(),
          desktopBody: const MenuDesktop(),
        ),
      ),
    );
  }
}
