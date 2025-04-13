import 'package:flutter/material.dart';
import '../constants.dart';
import '../../models/raktar_model.dart';

class RaktarWidget extends StatelessWidget {
  final RaktarModel raktar;

  const RaktarWidget({super.key, required this.raktar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 200, // Fix szélesség, hogy méretre egységes maradjon
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: listItemColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  raktar.nev,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (raktar.megjegyzes != null && raktar.megjegyzes!.isNotEmpty)
                  Text(
                    "Megjegyzés: ${raktar.megjegyzes}",
                    style: const TextStyle(fontSize: 14),
                  ),
                if (raktar.raktaronBelul != null && raktar.raktaronBelul!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    "Raktáron belül:",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  for (var szam in raktar.raktaronBelul!)
                    Text("• $szam"),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
