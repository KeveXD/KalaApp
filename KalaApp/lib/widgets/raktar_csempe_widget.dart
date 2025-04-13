import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/widgets/raktarak/raktar_widget_viewmodel.dart';
import '../constants.dart';
import '../../models/raktar_model.dart';

class RaktarCsempeWidget extends ConsumerWidget {
  final RaktarModel raktar;

  const RaktarCsempeWidget({super.key, required this.raktar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          ref.read(raktarWidgetViewModelProvider.notifier).selectRaktar(raktar);
        },
        child: Container(
          width: 200,
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
      ),
    );
  }
}
