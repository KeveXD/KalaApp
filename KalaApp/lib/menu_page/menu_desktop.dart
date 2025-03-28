import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart'; // A globális színpaletta importálása
import '../raktarak/eszkoz_view_model.dart';
import '../svg/jobb_raktar_svg.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/raktar_widget.dart';
import '../widgets/profil_widget.dart';

class MenuDesktop extends ConsumerWidget {
  const MenuDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eszkozState = ref.watch(eszkozViewModelProvider);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilWidget(),
                  // todo
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: JobbRaktarSvg(), // Itt helyettesítjük az SVG kódot a JobbRaktarSvg widgettel
                        ),
                      ),
                    ),
                  ),
                  // eddig
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
