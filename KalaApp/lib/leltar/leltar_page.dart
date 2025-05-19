// ignore: deprecated_import
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/raktarak/new_eszkoz_dialog.dart';
import '../constants.dart';
import '../raktarak/eszkoz_viewmodel.dart';
import '../widgets/profil_widget.dart';
import '../widgets/raktarak/raktar_widget.dart';
import '../models/eszkoz_model.dart';
import '../models/raktar_model.dart'; // Feltételezett raktár modell
import '../widgets/szuro_widget.dart'; // Importáljuk a SzuroWidgetet


// Távolítsuk el a feltételezett raktárViewModelProvider-t,
// mivel az EszkozViewModel-ből fogjuk lekérdezni a raktárakat.
// final raktarViewModelProvider = Provider((ref) => RaktarViewModel()); // Ezt töröld vagy kommenteld ki

class LeltarPage extends ConsumerStatefulWidget {
  const LeltarPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LeltarPage> createState() => _LeltarPageState();
}

class _LeltarPageState extends ConsumerState<LeltarPage> {
  html.VideoElement? _videoElement;
  final TextEditingController _barcodeController = TextEditingController();
  bool _isCameraOpen = false;

  // === Szűrési állapot változók ===
  String _searchQuery = '';
  String? _selectedWarehouse; // null, ha nincs kiválasztva
  bool _isFilterApplied = false; // Jelzi, hogy gombnyomásra lett-e szűrő alkalmazva
  bool _isFilterExpanded = false;
  // =================================

  // Annak a TextFieldnek a controllere, ami a SzuroWidget-ben van
  // Ezt használjuk a reseteléshez, ha szükség van rá.
  final TextEditingController _szuroSearchController = TextEditingController();


  @override
  void dispose() {
    _stopCamera();
    _barcodeController.dispose();
    _szuroSearchController.dispose(); // Fontos: dispose-olni kell
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    if (_isCameraOpen) {
      _stopCamera();
    } else {
      await _openCamera();
    }
    setState(() {
      _isCameraOpen = !_isCameraOpen;
    });
  }

  void _stopCamera() {
    _videoElement?.srcObject?.getTracks().forEach((track) => track.stop());
    html.document.getElementById('cameraContainer')?.children.clear();
    _videoElement = null;
  }

  Future<void> _openCamera() async {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..setAttribute('playsinline', '')
      ..style.width = '100%'
      ..style.height = '100%';

    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true});
      _videoElement!.srcObject = stream as html.MediaStream;

      // Ellenőrizzük, hogy a container létezik-e, mielőtt hozzáadjuk
      final container = html.document.getElementById('cameraContainer');
      if (container != null) {
        container.children.clear();
        container.append(_videoElement!);
      } else {
        // Ha a container valamiért nem létezik (bár registerViewFactory regisztrálta)
        print('Hiba: A cameraContainer HTML elem nem található.');
      }

    } catch (e) {
      // Általánosabb hiba kezelés
      print('Hiba a kamera megnyitásakor: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem sikerült megnyitni a kamerát')),
      );
    }
  }

  // === Módosított szűrési metódus ===
  // Mostantól ez a metódus végzi az ÖSSZES szűrést
  List<EszkozModel> _applyFilters({
    required List<EszkozModel> eszkozok, // Az eredeti lista
    required bool leltarozvaMaKereses, // A "leltározva ma" feltétel
    required String searchQuery,
    required String? selectedWarehouse,
    required bool isFilterApplied, // Jelzi, hogy a szűrés gombnyomásra történt-e
  }) {
    final today = DateTime.now();

    return eszkozok.where((eszkoz) {
      // Feltétel 1: Leltározva van-e ma?
      final leltarozvaMa = eszkoz.leltarozasok.any((l) {
        final datum = DateTime.tryParse(l.datum);
        return datum != null &&
            datum.year == today.year &&
            datum.month == today.month &&
            datum.day == today.day;
      });

      // Ellenőrizzük, hogy az eszköz megfelel-e a "leltározva ma" státusznak,
      // amit éppen keresünk (leltarozvaMaKereses).
      // Ha nem felel meg, kizárjuk az elemet ebből a listából.
      if (leltarozvaMaKereses ? !leltarozvaMa : leltarozvaMa) {
        return false;
      }

      // Ha nincs alkalmazva szűrő gombnyomásra, akkor a "leltározva ma" feltétel
      // után minden elem jöhet.
      if (!isFilterApplied) {
        return true;
      }

      // Ha szűrő alkalmazva van (gombnyomásra), további feltételeket ellenőrzünk:
      // Keresési feltétel (név vagy azonosító)
      final searchMatch = eszkoz.eszkozNev.toLowerCase().contains(searchQuery.toLowerCase()) ||
          eszkoz.eszkozAzonosito.toLowerCase().contains(searchQuery.toLowerCase());

      // Raktár feltétel
      final warehouseMatch = selectedWarehouse == null || eszkoz.lokacio == selectedWarehouse;

      // Az eszköz akkor kerül be, ha a keresési és a raktár feltétel is igaz
      return searchMatch && warehouseMatch;

    }).toList();
  }
  // ====================================


  Widget _buildEszkozCard(EszkozModel eszkoz, {bool clickable = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        title: Text(eszkoz.eszkozNev, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Azonosító: ${eszkoz.eszkozAzonosito}"),
        trailing: const Icon(Icons.qr_code),
        onTap: clickable
            ? () => showNewEszkozDialog(
          context,
          ref,
          existingEszkoz: eszkoz,
          isLeltar: true,
        )
            : null,
      ),
    );
  }

  // === Callback funkciók a SzuroWidgethez ===
  void _onSearchChanged(String query) {
    _searchQuery = query;
    // Ha gépelés közben is szeretnél azonnal szűrni (nem csak gombnyomásra),
    // akkor itt kellene hívni a setState()-et, ÉS módosítani az _isFilterApplied
    // logikát. Jelenleg a "Szűrés alkalmazása" gomb indítja a szűrést.
    if (!_isFilterApplied && query.isEmpty && _selectedWarehouse == null) {
      // Ha a keresőmező kiürül és nincs kiválasztott raktár,
      // de a szűrő ALKALMAZVA volt, kapcsoljuk ki a szűrést.
      // Ez egy lehetséges reset logika.
      // setState(() { _isFilterApplied = false; });
    } else if (query.isNotEmpty || _selectedWarehouse != null) {
      // Ha van tartalom a keresőben VAGY kiválasztott raktár,
      // és még nincs alkalmazva a szűrő, akkor tekintsük alkalmazottnak
      // az azonnali szűréshez.
      // setState(() { _isFilterApplied = true; });
    }
    //setState(() {}); // Azonnali szűrés gépelésre (vedd ki kommentből, ha ezt akarod)
  }

  void _onToggleExpanded(bool expanded) {
    setState(() {
      _isFilterExpanded = expanded;
    });
  }

  void _onApplyFilter() {
    setState(() {
      // A szűrés mostantól aktív a megadott feltételekkel
      _isFilterApplied = true;
      // Nincs külön setState hívás itt, mert a build metódusban a szűrt listák
      // lekérése már az állapotváltozóktól függ.
    });
  }

  // Lehetséges reset funkció a Szűrő Widgethez
  void _onResetFilter() {
    _szuroSearchController.clear(); // Tisztítjuk a TextField-et
    setState(() {
      _searchQuery = '';
      _selectedWarehouse = null;
      _isFilterApplied = false; // Kikapcsoljuk a szűrést
      _isFilterExpanded = false; // Összecsukjuk a szűrőt resetelés után
    });
  }


  void _onWarehouseChanged(String? newValue) {
    setState(() {
      _selectedWarehouse = newValue;
      // Ha azonnali szűrést szeretnél gomb nélkül, itt kellene setState()-et hívni
      // setState(() {}); // Azonnali szűrés raktár választásra (vedd ki kommentből, ha ezt akarod)
    });
  }
  // ==========================================


  @override
  Widget build(BuildContext context) {
    // Teljes eszköz lista lekérése Riverpodból
    final eszkozState = ref.watch(eszkozViewModelProvider);
    final List<EszkozModel> osszesEszkoz = eszkozState.eszkozok;

    // Raktár adatok lekérése Riverpodból, az EszkozViewModel-ből
    // Feltételezzük, hogy EszkozViewModel.raktarak tartalmazza a List<RaktarModel>-t
    final List<RaktarModel> osszesRaktar = eszkozState.raktarak; // HASZNÁLD A SAJÁT MODELLEZÉSEDET!


    // Készítjük el a DropdownButton elemeket
    final List<DropdownMenuItem<String>> raktarDropdownItems = [
      const DropdownMenuItem(
        value: null, // Lehetővé teszi a "Nincs kiválasztva" opciót
        child: Text('Összes raktár'),
      ),
      ...osszesRaktar.map((raktar) => DropdownMenuItem(
        value: raktar.nev, // Feltételezett raktárnév property
        child: Text(raktar.nev),
      )).toList(),
    ];

    // Létrehozzuk a raktár dropdown widgetet
    final raktarDropdownWidget = DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorderColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      hint: const Text('Válasszon raktárt'),
      value: _selectedWarehouse,
      items: raktarDropdownItems,
      onChanged: _onWarehouseChanged,
    );


    // Szűrt listák lekérése a módosított metódussal
    // Mindkét listát az ÖSSZES eszközből szűrjük, a "leltározva ma" státusz alapján
    final nemLeltarozottEszkozok = _applyFilters(
      eszkozok: osszesEszkoz, // Az összes eszközből indulunk ki
      leltarozvaMaKereses: false, // Csak azokat keressük, amik NINCSENEK ma leltározva
      searchQuery: _searchQuery,
      selectedWarehouse: _selectedWarehouse,
      isFilterApplied: _isFilterApplied,
    );
    final leltarozottEszkozok = _applyFilters(
      eszkozok: osszesEszkoz, // Az összes eszközből indulunk ki
      leltarozvaMaKereses: true, // Csak azokat keressük, amik VANNAK ma leltározva
      searchQuery: _searchQuery,
      selectedWarehouse: _selectedWarehouse,
      isFilterApplied: _isFilterApplied,
    );


    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding( // Padding az egész tartalom körül
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bal oldali Drawer/Navigáció (fixen áll)
            myDrawer,
            const SizedBox(width: 16),

            // Középső, GÖRGETHETŐ tartalom terület
            Expanded( // Ez az Expanded biztosítja, hogy a középső rész kitölti a helyet
              flex: 4,
              // === Itt jön a SingleChildScrollView, ami görgethetővé teszi a tartalmát ===
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Kinyújtjuk a gyerekeket
                  children: [
                    // Kamera gomb
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                      ),
                      onPressed: _toggleCamera,
                      icon: Icon(_isCameraOpen ? Icons.close : Icons.camera_alt),
                      label: Text(_isCameraOpen ? 'Kamera leállítása' : 'Kamera megnyitása'),
                    ),
                    const SizedBox(height: 16),

                    // Kameranézet (csak ha nyitva van)
                    if (_isCameraOpen) ...[
                      Text(
                        'Kameranézet:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // A kamera widget is a SingleChildScrollView része lesz,
                      // de fix magasságot kap.
                      const SizedBox(
                        height: 400,
                        child: HtmlElementView(viewType: 'camera-container'),
                      ),
                      const SizedBox(height: 16), // Távolság a kamera és a szűrő között
                    ],

                    // === Szűrő Widget ===
                    SzuroWidget(
                      isFilterExpanded: _isFilterExpanded,
                      isFilterApplied: _isFilterApplied,
                      searchQuery: _searchQuery,
                      onSearchChanged: _onSearchChanged, // Callback a keresőmező változásakor
                      onToggleExpanded: _onToggleExpanded, // Callback a kibontás/összecsukás gombra
                      onApplyFilter: _onApplyFilter, // Callback a "Szűrés alkalmazása" gombra
                      dropdownWidget: raktarDropdownWidget, // Átadjuk a raktár dropdown widgetet
                      //searchController: _szuroSearchController, // Átadjuk a controllert a TextField-nek
                    ),
                    const SizedBox(height: 16), // Távolság a szűrő és a listák között
                    // ====================

                    // Listák egymás mellett (nincs Expanded a külső Row-on)
                    // A belső listák (ListView.builder) shrinkWrap és NeverScrollableScrollPhysics
                    // használatával görgetnek majd a külső SingleChildScrollView-val.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Igazítás felülre
                      children: [
                        // Nincs leltározva lista
                        Expanded( // Itt is szükség van az Expanded-re, hogy a két lista kitöltse a Row szélességét
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Itt NINCS Expanded, mert a szülő Column a SingleChildScrollView-ban van
                            children: [
                              Text(
                                // Jelöljük a címnél, ha aktív a szűrés
                                'Eszközök (nincs ma leltározva${_isFilterApplied ? " - Szűrve" : ""}):',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // A ListView.builder-t nem kell Expanded-be tenni,
                              // a shrinkWrap és physics gondoskodik róla, hogy a szülő
                              // SingleChildScrollView-val görgessen.
                              ListView.builder(
                                shrinkWrap: true, // A lista csak akkora helyet foglal, amennyit a tartalma igényel
                                physics: const NeverScrollableScrollPhysics(), // Megakadályozza a belső görgetést
                                itemCount: nemLeltarozottEszkozok.length,
                                itemBuilder: (context, index) => _buildEszkozCard(
                                  nemLeltarozottEszkozok[index],
                                  clickable: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 32),
                        // Leltározva lista
                        Expanded( // Itt is szükség van az Expanded-re, hogy a két lista kitöltse a Row szélességét
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Itt NINCS Expanded
                            children: [
                              Text(
                                // Jelöljük a címnél, ha aktív a szűrés
                                'Eszközök (ma már leltározva${_isFilterApplied ? " - Szűrve" : ""}):',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              // A ListView.builder-t nem kell Expanded-be tenni
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: leltarozottEszkozok.length,
                                itemBuilder: (context, index) => _buildEszkozCard(
                                  leltarozottEszkozok[index],
                                  clickable: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // === SingleChildScrollView vége ===
            ),
            const SizedBox(width: 16),

            // Jobb oldali Profil/Raktár widgetek (fixen állnak)
            Expanded( // Ez az Expanded biztosítja, hogy a jobb oldali rész kitölti a helyet
              flex: 1,
              child: Column(
                children: const [
                  ProfilWidget(),
                  SizedBox(height: 16),
                  RaktarWidget(), // Ez a widget a raktárak listáját jelenítheti meg UI-ként
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void registerCameraContainer() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'camera-container',
        (int viewId) => html.DivElement()..id = 'cameraContainer',
  );
}

// --- Feltételezett RaktarViewModel és RaktarModel ---
// Ezeknek illeszkedniük kell a saját modelljeidhez és ViewModeledhez!
// Fontos, hogy az EszkozViewModel rendelkezzen egy raktarak getterrel.

/*
// Példa, hogyan nézhet ki RaktarModel és EszkozViewModel a raktarak getterrel:
class RaktarModel {
  final String id; // Ha van azonosító
  final String raktarNev;
  // ... további property-k

  RaktarModel({required this.id, required this.raktarNev});

  // Lehet, hogy szükséged lesz equals és hashCode override-okra
}

// A saját EszkozViewModeledbe ADD HOZZÁ ezt a gettert:
class EszkozViewModel extends ChangeNotifier {
  List<EszkozModel> _eszkozok = [];
  // ... további állapotok és metódusok

  List<EszkozModel> get eszkozok => _eszkozok;

  // Vagy explicit tárolod a raktárakat:
  // List<RaktarModel> _raktarak = [];
  // List<RaktarModel> get raktarak => _raktarak;

  // VAGY dinamikusan generálod az eszközök lokációjából:
  List<RaktarModel> get raktarak {
    final uniqueLocations = _eszkozok.map((e) => e.lokacio).where((l) => l != null).toSet();
    return uniqueLocations.map((loc) => RaktarModel(id: loc!, raktarNev: loc!)).toList(); // Feltételezve, hogy lokacio string és egyben a név is
  }

  // ... többi metódus (betöltés, mentés, stb.)
}
*/
// -----------------------------------------------