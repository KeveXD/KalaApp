import 'package:flutter/material.dart';
import '../constants.dart'; // A globális színpaletta importálása
import '../utils/elem_model.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/profil_widget.dart'; // Az új ProfilWidget importálása

class MenuDesktop extends StatefulWidget {
  const MenuDesktop({Key? key}) : super(key: key);

  @override
  State<MenuDesktop> createState() => _MenuDesktopState();
}

class _MenuDesktopState extends State<MenuDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor, // A háttér szín beállítása
      appBar: myAppBar, // AppBar a színpalettával
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Növelt padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myDrawer, // Oldalsó menü

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 4,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (context, index) {
                          return RaktarWidget();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ElemModel();
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ProfilWidget az első konténerben

                  ProfilWidget(
                    name: "Keve",
                    role: "Felhasználó",
                    hasDebt: false,
                  ),

                  // Második Container
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: listItemColor,
                          boxShadow: [
                            BoxShadow(
                              color: cardShadowColor.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
