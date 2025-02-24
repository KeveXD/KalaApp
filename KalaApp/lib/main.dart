import 'package:flutter/material.dart';

import 'menu_page/menu_desktop.dart';
import 'menu_page/menu_mobil.dart';
import 'menu_page/menu_tablet.dart';
import 'utils/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
