import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../raktarak/eszkoz_view_model.dart';
import '../widgets/eszkoz_widget.dart';
import '../widgets/raktar_widget.dart';

class MenuTablet extends ConsumerWidget {
  const MenuTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eszkozState = ref.watch(eszkozViewModelProvider);

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Raktárak vízszintesen görgethető
            SizedBox(
              height: 130,
              child: eszkozState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: eszkozState.raktarak.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final raktar = eszkozState.raktarak[index];
                  return RaktarWidget(raktar: raktar);
                },
              ),
            ),

            // Eszközök listája
            Expanded(
              child: eszkozState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: eszkozState.eszkozok.length,
                itemBuilder: (context, index) {
                  final eszkoz = eszkozState.eszkozok[index];
                  return EszkozWidget(eszkoz: eszkoz);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
