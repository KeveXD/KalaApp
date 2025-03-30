import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../models/eszkoz_model.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/raktarak/jobb_raktar_widget.dart';
import '../widgets/talca_widget.dart';
import 'eszkoz_view_model.dart';
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

    // Szűrt eszközök
    List<EszkozModel> filteredEszkozok = eszkozState.eszkozok.where((eszkoz) {
      return (!isFilterApplied ||
          (eszkoz.eszkozNev.toLowerCase().contains(searchQuery.toLowerCase()) &&
              (selectedWarehouse == null || eszkoz.lokacio == selectedWarehouse)));
    }).toList();

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar, // Az app bar
      drawer: myDrawer, // Bal oldali menü
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bal oldalon mindig nyitva lévő drawer
            Expanded(
              flex: 1,
              child: myDrawer,
            ),
            // Középső tartalom (eszközök listája és szűrő)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text(
                            "Szűrés",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            icon: Icon(isFilterExpanded ? Icons.expand_less : Icons.expand_more),
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
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Keresés név szerint",
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: "Raktár kiválasztása",
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedWarehouse,
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: null,
                                      child: Text("Minden raktár"),
                                    ),
                                    ...eszkozState.raktarakNevei.map((warehouse) {
                                      return DropdownMenuItem(
                                        value: warehouse,
                                        child: Text(warehouse),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedWarehouse = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
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
                        final eszkoz = filteredEszkozok[index];
                        return EszkozWidget(eszkoz: eszkoz);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Jobb oldalon a profil és jobb raktár widgetek
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
          TalcaItem(
            icon: Icons.home,
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
          ),
          TalcaItem(
            icon: Icons.add_circle,
            onTap: () {
              showNewEszkozDialog(context);
            },
          ),
          TalcaItem(
            icon: Icons.person,
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
        ],
      ),
    );
  }
}
