import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../models/eszkoz_model.dart';
import '../models/megjegyzes_model.dart';
import 'eszkoz_viewmodel.dart';

class EszkozSzerkesztesPage extends ConsumerStatefulWidget {
  final EszkozModel eszkoz;
  final bool isLeltar;

  const EszkozSzerkesztesPage({
    Key? key,
    required this.eszkoz,
    this.isLeltar = false,
  }) : super(key: key);

  @override
  _SetEszkozPageState createState() => _SetEszkozPageState();
}

class _SetEszkozPageState extends ConsumerState<EszkozSzerkesztesPage> {
  late TextEditingController nevController;
  late TextEditingController azonositoController;
  late TextEditingController lokacioController;
  late TextEditingController felelosController;
  late TextEditingController kinelVanController;
  late TextEditingController ertekController;
  List<MegjegyzesModel> megjegyzesek = [];

  @override
  void initState() {
    super.initState();
    nevController = TextEditingController(text: widget.eszkoz.eszkozNev);
    azonositoController = TextEditingController(text: widget.eszkoz.eszkozAzonosito);
    lokacioController = TextEditingController(text: widget.eszkoz.lokacio);
    felelosController = TextEditingController(text: widget.eszkoz.felelosNev);
    kinelVanController = TextEditingController(text: widget.eszkoz.kinelVan);
    ertekController = TextEditingController(text: widget.eszkoz.ertek?.toString() ?? '0');
    megjegyzesek = List.from(widget.eszkoz.megjegyzesek);
  }

  @override
  Widget build(BuildContext context) {
    final isLeltar = widget.isLeltar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          isLeltar ? "Leltár - Eszköz ellenőrzés" : "Eszköz szerkesztése",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Eszköz neve", nevController),
            _buildTextField("Azonosító", azonositoController),
            _buildTextField("Lokáció", lokacioController),
            _buildTextField("Felelős", felelosController),
            _buildTextField("Kinél van", kinelVanController),
            _buildTextField("Érték (Ft)", ertekController, isNumber: true),
            const SizedBox(height: 16),
            _buildMegjegyzesek(),
            const SizedBox(height: 24),

            // Gombok
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _mentes(ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLeltar ? Colors.green : buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    isLeltar ? "Leltár mentése" : "Mentés",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (isLeltar)
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: const Text("Leltár elvetése", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: inputFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: inputBorderColor),
          ),
        ),
      ),
    );
  }

  Widget _buildMegjegyzesek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Megjegyzések:", style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor)),
        const SizedBox(height: 8),
        ...megjegyzesek.asMap().entries.map((entry) {
          int index = entry.key;
          MegjegyzesModel megjegyzes = entry.value;
          return Card(
            color: cardBackgroundColor,
            shadowColor: cardShadowColor,
            child: ListTile(
              title: Text(megjegyzes.megjegyzes, style: TextStyle(color: primaryTextColor)),
              subtitle: Text(megjegyzes.felhasznaloNev, style: TextStyle(color: secondaryTextColor)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    megjegyzesek.removeAt(index);
                  });
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _mentes(WidgetRef ref) async {
    final eszkozViewModel = ref.read(eszkozViewModelProvider.notifier);

    EszkozModel frissitettEszkoz = widget.eszkoz.copyWith(
      eszkozNev: nevController.text,
      eszkozAzonosito: azonositoController.text,
      lokacio: lokacioController.text,
      felelosNev: felelosController.text,
      kinelVan: kinelVanController.text,
      ertek: double.tryParse(ertekController.text) ?? 0.0,
      megjegyzesek: megjegyzesek,
    );

    await eszkozViewModel.addNewEszkoz(frissitettEszkoz);

    if (mounted) {
      Navigator.pop(context, frissitettEszkoz);
    }
  }
}
