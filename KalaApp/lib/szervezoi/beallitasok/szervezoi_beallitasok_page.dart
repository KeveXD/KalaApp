import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/szervezoi/beallitasok/szervezoi_viewmodel.dart';
import 'package:kalaapp/widgets/drawer_widget.dart';

import '../../raktarak/eszkoz_viewmodel.dart';

class SzervezoiBeallitasokPage extends ConsumerStatefulWidget {
  @override
  _SzervezoiBeallitasokPageState createState() =>
      _SzervezoiBeallitasokPageState();
}

class _SzervezoiBeallitasokPageState
    extends ConsumerState<SzervezoiBeallitasokPage> {
  final TextEditingController nevController = TextEditingController();
  final TextEditingController megjegyzesController = TextEditingController();
  final TextEditingController reszController = TextEditingController();

  void _addResz() {
    if (reszController.text.isNotEmpty) {
      final int? resz = int.tryParse(reszController.text);
      if (resz != null) {
        ref.read(szervezoiViewModelProvider.notifier).addResz(resz);
        reszController.clear();
      }
    }
  }

  void _addRaktar() {
    final String nev = nevController.text;
    final String? megjegyzes =
    megjegyzesController.text.isNotEmpty ? megjegyzesController.text : null;

    if (nev.isNotEmpty) {
      ref.read(szervezoiViewModelProvider.notifier).addRaktar(nev, megjegyzes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Raktár hozzáadva: $nev")),
      );

      nevController.clear();
      megjegyzesController.clear();

      // Meghívjuk a fetchRaktarak függvényt az eszkozViewModel-ben
      ref.read(eszkozViewModelProvider.notifier).fetchRaktarak();
    }
  }


  @override
  Widget build(BuildContext context) {
    final raktarReszek = ref.watch(szervezoiViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFB2A68E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF655849),
        title: const Text("Szervezői Beállítások"),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0xFFEBE3D9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Raktár Hozzáadása",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                          controller: nevController, label: "Raktár Neve"),
                      const SizedBox(height: 10),
                      _buildTextField(
                          controller: megjegyzesController,
                          label: "Megjegyzés"),
                      const SizedBox(height: 10),
                      _buildReszHozzaadas(),
                      const SizedBox(height: 10),
                      _buildReszekListaja(raktarReszek),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>{_addRaktar},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E3B31),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Hozzáadás"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFEBE3D9),
      ),
    );
  }

  Widget _buildReszHozzaadas() {
    return TextField(
      controller: reszController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Raktár Rész Hozzáadása",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFEBE3D9),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add, color: Colors.brown),
          onPressed: _addResz,
        ),
      ),
    );
  }

  Widget _buildReszekListaja(List<int> raktarReszek) {
    return Wrap(
      children: raktarReszek.asMap().entries.map((entry) {
        int index = entry.key;
        int value = entry.value;
        return Chip(
          label: Text("$value"),
          backgroundColor: const Color(0xFF8C7D66),
          deleteIcon: const Icon(Icons.close, color: Colors.white),
          onDeleted: () =>
              ref.read(szervezoiViewModelProvider.notifier).removeResz(index),
        );
      }).toList(),
    );
  }
}
