import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart'; // A globális színpaletta importálása
import '../raktarak/eszkoz_viewmodel.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/raktar_csempe_widget.dart';
import '../widgets/profil_widget.dart';
import '../widgets/raktarak/raktar_widget.dart';
import '../widgets/raktarak/raktar_widget_viewmodel.dart';

class MenuDesktop extends ConsumerWidget {
  const MenuDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eszkozState = ref.watch(eszkozViewModelProvider);
    final raktarState = ref.watch(raktarWidgetViewModelProvider);

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
                  SizedBox(
                    height: 130, // vagy amennyi kell az egy raktármagassághoz
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: eszkozState.raktarak.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final raktar = eszkozState.raktarak[index];
                        return RaktarCsempeWidget(raktar: raktar); // <-- átadjuk a modellt
                      },
                    ),
                  ),

                  Expanded(
                    child: eszkozState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: eszkozState.eszkozok.length,
                      itemBuilder: (context, index) {
                        final eszkoz = eszkozState.eszkozok[index];
                        return EszkozWidget(eszkoz: eszkoz);
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfilWidget(),

                  RaktarWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
