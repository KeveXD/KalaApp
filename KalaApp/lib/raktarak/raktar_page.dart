import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/eszkoz_model.dart';

class RaktarPage extends StatefulWidget {
  const RaktarPage({Key? key}) : super(key: key);

  @override
  State<RaktarPage> createState() => _RaktarPageState();
}

class _RaktarPageState extends State<RaktarPage> {
  String? selectedWarehouse; // Kiválasztott raktár
  double minValue = 0; // Minimum érték szűréshez
  double maxValue = 100000; // Maximum érték szűréshez
  String searchQuery = ""; // Keresési szöveg

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Szűrőpanel
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Szűrés",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Keresés név szerint
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

                  // Érték szerinti szűrés
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

                  // Raktár kiválasztása
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
            const SizedBox(height: 16),

            // Görgethető lista az eszközökkel
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Példaadat
                itemBuilder: (context, index) {
                  return EszkozModel(); // Itt kerülnek listázásra az eszközök
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
