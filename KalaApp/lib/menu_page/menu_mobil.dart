import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/widgets/raktar_widget.dart';
import '../constants.dart';
import '../raktarak/eszkoz_viewmodel.dart';
import '../widgets/eszkoz_widget.dart';

class MenuMobil extends ConsumerWidget {
  const MenuMobil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eszkozState = ref.watch(eszkozViewModelProvider);

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(''),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // RAKTÁRAK vízszintesen görgethetően
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

            // ESZKÖZ LISTA
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
