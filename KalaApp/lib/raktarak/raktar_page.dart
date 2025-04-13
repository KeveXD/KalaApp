import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../models/eszkoz_model.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/raktarak/jobb_raktar_widget.dart';
import '../widgets/talca_widget.dart';
import 'eszkoz_viewmodel.dart';
import 'new_eszkoz.dart';
import '../widgets/profil_widget.dart';

class RaktarPage extends ConsumerStatefulWidget {
  const RaktarPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RaktarPage> createState() => _RaktarPageState();
}

class _RaktarPageState extends ConsumerState<RaktarPage> {
  String? selectedWarehouse;
  String searchQuery = "";
  bool isFilterExpanded = false;
  bool isFilterApplied = false;

  @override
  Widget build(BuildContext context) {
    final eszkozState = ref.watch(eszkozViewModelProvider);
    List<EszkozModel> filteredEszkozok = eszkozState.eszkozok.where((eszkoz) {
      return (!isFilterApplied ||
          (eszkoz.eszkozNev.toLowerCase().contains(searchQuery.toLowerCase()) &&
              (selectedWarehouse == null || eszkoz.lokacio == selectedWarehouse)));
    }).toList();

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: myDrawer),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: cardBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Szűrés", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor)),
                          trailing: IconButton(
                            icon: Icon(isFilterExpanded ? Icons.expand_less : Icons.expand_more, color: iconColor),
                            onPressed: () {
                              setState(() {
                                isFilterExpanded = !isFilterExpanded;
                              });
                            },
                          ),
                        ),
                        if (isFilterExpanded)
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                _buildStyledTextField("Keresés név szerint", Icons.search, (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                }),
                                const SizedBox(height: 10),
                                _buildStyledDropdown(),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    foregroundColor: buttonTextColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isFilterApplied = true;
                                    });
                                  },
                                  child: const Text("Szűrés alkalmazása"),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: eszkozState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredEszkozok.isEmpty
                        ? const Center(child: Text("Nincsenek elérhető eszközök."))
                        : ListView.builder(
                      itemCount: filteredEszkozok.length,
                      itemBuilder: (context, index) {
                        return EszkozWidget(eszkoz: filteredEszkozok[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfilWidget(),
                  JobbRaktarWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TalcaWidget(
        items: [
          TalcaItem(icon: Icons.home, onTap: () => Navigator.pushNamed(context, "/home")),
          TalcaItem(icon: Icons.add_circle, onTap: () => showNewEszkozDialog(context)),
          TalcaItem(icon: Icons.person, onTap: () => Navigator.pushNamed(context, "/profile")),
        ],
      ),
    );
  }

  Widget _buildStyledTextField(String label, IconData icon, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
        fillColor: inputFieldColor,
        filled: true,
        prefixIcon: Icon(icon, color: iconColor),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildStyledDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Raktár kiválasztása",
        border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
        fillColor: inputFieldColor,
        filled: true,
      ),
      value: selectedWarehouse,
      items: [
        DropdownMenuItem(value: null, child: Text("Minden raktár")),
        ...ref.watch(eszkozViewModelProvider).raktarakNevei.map((warehouse) {
          return DropdownMenuItem(value: warehouse, child: Text(warehouse));
        }).toList(),
      ],
      onChanged: (value) {
        setState(() {
          selectedWarehouse = value;
        });
      },
    );
  }
}
