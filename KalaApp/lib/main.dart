import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'leltar/leltar_page.dart';
import 'dart:ui' as ui;
import 'menu_page/menu_desktop.dart';
import 'menu_page/menu_mobil.dart';
import 'menu_page/menu_tablet.dart';
import 'utils/responsive_layout.dart';

void main() async {
  registerCameraContainer();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase inicializálása kell
  runApp(ProviderScope(child: MyApp())); // ProviderScope köré csomagolva
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: ResponsiveLayout(
        mobileBody: const MenuMobil(),
        tabletBody: const MenuTablet(),
        desktopBody: const MenuDesktop(),
      ),
    );
  }
}
