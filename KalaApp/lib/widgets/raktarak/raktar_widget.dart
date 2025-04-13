import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/svg/svg_viewmodel.dart';
import 'package:kalaapp/svg/bal_raktar_svg.dart';
import 'package:kalaapp/widgets/raktarak/raktar_widget_viewmodel.dart';

import '../../constants.dart';
import '../../models/raktar_model.dart';
import '../../svg/jobb_raktar_svg.dart';

class RaktarWidget extends ConsumerStatefulWidget {


  const RaktarWidget({Key? key,}) : super(key: key);

  @override
  _RaktarWidgetState createState() => _RaktarWidgetState();
}

class _RaktarWidgetState extends ConsumerState<RaktarWidget> {
  String selectedShelf = '0';

  @override
  Widget build(BuildContext context) {
    final svgState = ref.watch(svgViewModelProvider);
    final raktarState =ref.watch(raktarWidgetViewModelProvider);
    final selectedId = svgState.selectedId;

    String raktarNev = raktarState?.selectedRaktar.nev ?? 'Raktár';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: listItemColor,
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
              raktarNev,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔽 Kiválasztott csempe megjelenítése
                  Text(
                    selectedId != null
                        ? 'Kiválasztott csempe: $selectedId'
                        : 'Nincs kiválasztva csempe',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SVG megjelenítése a raktár neve alapján
                  raktarNev == "jobbraktar" ? JobbRaktarSvg() : BalRaktarSvg(),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selectedShelf,
                        items: List.generate(5, (index) {
                          return DropdownMenuItem<String>(
                            value: index.toString(),
                            child: Text('Polc $index'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedShelf = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          print('Polc $selectedShelf kiválasztva');
                        },
                        child: const Text('Mehet'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: buttonTextColor,
                          backgroundColor: buttonColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
