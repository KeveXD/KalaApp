import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/eszkoz_widget.dart';
import '../utils/eszkoz_widget.dart';
import '../widgets/talca_widget.dart';
import 'new_eszkoz.dart'; // Az alsó tálca widget importálása

class RaktarPage extends StatefulWidget {
  const RaktarPage({Key? key}) : super(key: key);

  @override
  State<RaktarPage> createState() => _RaktarPageState();
}

class _RaktarPageState extends State<RaktarPage> {
  String? selectedWarehouse;
  double minValue = 0;
  double maxValue = 100000;
  String searchQuery = "";
  bool isFilterExpanded = false; // Szűrőpanel állapota

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Min. érték",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      minValue = double.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Max. érték",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      maxValue = double.tryParse(value) ?? 100000;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Raktár kiválasztása",
                              border: OutlineInputBorder(),
                            ),
                            items: ["Raktár 1", "Raktár 2", "Raktár 3"]
                                .map((warehouse) => DropdownMenuItem(
                              value: warehouse,
                              child: Text(warehouse),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedWarehouse = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return EszkozWidget();
                },
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
              print("Navigáció a kezdőképernyőre");
              // Navigator.pushNamed(context, "/home"); // Ha van route hozzá
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
              print("Profil megnyitása");
              // Navigator.pushNamed(context, "/profile"); // Ha van route hozzá
            },
          ),
        ],
      ),
    );
  }
}
