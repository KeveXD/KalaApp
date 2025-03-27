import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/profil/profil_view_model.dart';
import 'package:kalaapp/widgets/drawer_widget.dart';
import '../constants.dart';
import '../raktarak/eszkoz_view_model.dart';
import '../widgets/profil_widget.dart';
import '../widgets/eszkoz_widget.dart';

class ProfilPage extends ConsumerStatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  bool showCurrentDevices = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profilViewModelProvider.notifier).fetchProfilData();
    });
  }


  @override
  Widget build(BuildContext context) {
    final profilState = ref.watch(profilViewModelProvider);
    final eszkozState = ref.watch(eszkozViewModelProvider);

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
            // Profil adatok
            ProfilWidget(
              showBeallitasok: true,
            ),
            SizedBox(height: 20),
            // Váltó gomb a jelenlegi és előzmény eszközök között
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
              child: profilState == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: showCurrentDevices
                    ? profilState.jelenlegiEszkozok.length
                    : profilState.elozmenyEszkozok.length,
                itemBuilder: (context, index) {
                  final eszkoz = showCurrentDevices
                      ? profilState.jelenlegiEszkozok[index]
                      : profilState.elozmenyEszkozok[index];

                  return EszkozWidget(eszkoz: eszkoz);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
