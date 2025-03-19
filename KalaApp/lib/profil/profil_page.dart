import 'package:flutter/material.dart';
import 'package:kalaapp/widgets/drawer_widget.dart';
import '../constants.dart';
import '../models/eszkoz_model.dart';
import '../widgets/profil_widget.dart';
import '../widgets/eszkoz_widget.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool showCurrentDevices = true;

  final List<String> currentDevices = [
    'Laptop - Dell XPS 15',
    'Telefon - Samsung Galaxy S23',
    'Tablet - iPad Pro 12.9',
    'Okosóra - Apple Watch Series 8',
  ];

  final List<String> previousDevices = [
    'Régi Laptop - Lenovo ThinkPad',
    'Régi Telefon - iPhone 8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Profil', style: TextStyle(color: buttonTextColor)),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ProfilWidget beépítése
            ProfilWidget(
              showBeallitasok: true,

            ),
            SizedBox(height: 20),
            // Váltó gomb
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCurrentDevices ? buttonColor : inputBorderColor,
                    ),
                    onPressed: () {
                      setState(() {
                        showCurrentDevices = true;
                      });
                    },
                    child: Text(
                      'Jelenlegi eszközök',
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCurrentDevices ? inputBorderColor : buttonColor,
                    ),
                    onPressed: () {
                      setState(() {
                        showCurrentDevices = false;
                      });
                    },
                    child: Text(
                      'Előzmény eszközök',
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Eszközök listázása
            Expanded(
              child: ListView.builder(
                itemCount: showCurrentDevices ? currentDevices.length : previousDevices.length,
                itemBuilder: (context, index) {
                  return EszkozWidget(
                    eszkoz: EszkozModel(
                      eszkozNev: 'N/A',
                      eszkozAzonosito: 'N/A',
                      lokacio: 'N/A',
                      felelosNev: 'N/A',
                      megjegyzesek: [],
                      kepek: [], komment: 'loool',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
