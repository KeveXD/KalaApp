import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:kalaapp/widgets/raktarak/raktar_widget_viewmodel.dart';
import '../constants.dart';
import '../login/login_viewmodel.dart';
import '../models/eszkoz_model.dart';
import '../raktarak/eszkoz_viewmodel.dart';
import '../raktarak/eszkoz_szerkesztes_page.dart';
import '../svg/svg_viewmodel.dart';

class EszkozWidget extends riverpod.ConsumerStatefulWidget  {
  final EszkozModel eszkoz;

  const EszkozWidget({Key? key, required this.eszkoz}) : super(key: key);

  @override
  riverpod.ConsumerState<EszkozWidget> createState() => _EszkozWidgetState();
}

class _EszkozWidgetState extends riverpod.ConsumerState<EszkozWidget> {
  bool isExpanded = false;



  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _megjegyzesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final aktualisFelhasznalo = ref.watch(loginViewModelProvider).felhasznalo;
    final eszkozState = ref.watch(eszkozViewModelProvider);
    final raktarState = ref.watch(raktarWidgetViewModelProvider);
    final svgState = ref.watch(svgViewModelProvider);


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [

          // Fő listaelem
          Container(
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: cardShadowColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:


        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: inputBorderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.white),
          ),
          title: Text(
            widget.eszkoz.eszkozNev,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          subtitle: Text(
            "Nála van: ${widget.eszkoz.felelosNev}",
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: eszkozState.eszkozok.any((e) => e.eszkozAzonosito == widget.eszkoz.eszkozAzonosito && e.kinelVan == aktualisFelhasznalo?.email),
                onChanged: (value) async {
                  await ref.read(eszkozViewModelProvider.notifier).setKinelVanAzEszkoz(widget.eszkoz, value!, aktualisFelhasznalo);
                },

              ),


              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: iconColor,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;

                    if (isExpanded) {

                      final selectedRaktar = eszkozState.raktarak.firstWhere(
                            (raktar) => raktar.nev == widget.eszkoz.lokacio,
                        orElse: () => eszkozState.raktarak.first,
                      );
                      ref.read(raktarWidgetViewModelProvider.notifier).selectRaktar(selectedRaktar);

                      ref.read(svgViewModelProvider.notifier).updateState(id: widget.eszkoz.raktaronBelul.toString());
                    }
                  });
                },
              ),

            ],
          ),
        )


          ),

          // Lenyitható rész
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: drawerBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: iconColor),
                    onPressed: () {
                      // Ide jöhet a szerkesztési logika
                      print("Szerkesztés megnyitva");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EszkozSzerkesztesPage(eszkoz: widget.eszkoz),
                        ));
                    },
                  ),

                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: inputFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Eszköz száma: ${widget.eszkoz.eszkozAzonosito}",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                color: primaryTextColor)),
                        Text("Eszköz neve: ${widget.eszkoz.eszkozNev}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Eszköz értéke: ${widget.eszkoz.ertek ?? 0} Ft",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Eszköz helye: ${widget.eszkoz.lokacio}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Felelőse: ${widget.eszkoz.felelosNev}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Kinél van most: ${widget.eszkoz.kinelVan}",
                            style: TextStyle(color: primaryTextColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Megjegyzések lista
                  Text(
                    "Megjegyzések:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: widget.eszkoz.megjegyzesek.map((megjegyzes) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: inputFieldColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${megjegyzes.felhasznaloNev}: ${megjegyzes
                              .megjegyzes}",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Megjegyzés hozzáadása mező és küldés gomb
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _megjegyzesController,
                          decoration: InputDecoration(
                            hintText: "Írj egy megjegyzést...",
                            hintStyle: TextStyle(color: secondaryTextColor),
                            filled: true,
                            fillColor: inputFieldColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          style: TextStyle(color: primaryTextColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: buttonColor,
                          shape: BoxShape.circle,
                        ),
                        child: riverpod.Consumer(
                          builder: (context, ref, _) {
                            return IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () {
                                _sendMegjegyzes(ref);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

//fontos
                  SizedBox(
                    height: 120,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: inputBorderColor, // Placeholder szín
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.photo_camera, color: Colors.white, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lapozás indikátor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index ? primaryTextColor : secondaryTextColor.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
    //fontos
                ],
              ),

    );
  }

  void _sendMegjegyzes(riverpod.WidgetRef ref) async {
    String megjegyzesSzoveg = _megjegyzesController.text.trim();
    if (megjegyzesSzoveg.isEmpty) return;

    try {
      // A createMegjegyzes metódus elérése az eszkozViewModelProvider segítségével
      final ujMegjegyzes = await ref.read(eszkozViewModelProvider.notifier)
          .createMegjegyzes(megjegyzesSzoveg, ref);

      if (ujMegjegyzes != null) {
        // Megjegyzés hozzáadása az adott eszközhöz
        await ref.read(eszkozViewModelProvider.notifier).addMegjegyzesToEszkoz(
            widget.eszkoz, ujMegjegyzes);

        // TextField ürítése
        _megjegyzesController.clear();
      }
    } catch (e) {
      print("Hiba a megjegyzés küldésekor: $e");
    }
  }
}

