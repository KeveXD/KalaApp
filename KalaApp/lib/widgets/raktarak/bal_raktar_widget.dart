import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/svg/svg_viewmodel.dart';
import 'package:kalaapp/svg/bal_raktar_svg.dart';

import '../../constants.dart';

class BalRaktarWidget extends ConsumerStatefulWidget {
  const BalRaktarWidget({Key? key}) : super(key: key);

  @override
  _BalRaktarWidgetState createState() => _BalRaktarWidgetState();
}

class _BalRaktarWidgetState extends ConsumerState<BalRaktarWidget> {
  String selectedShelf = '0';

  @override
  Widget build(BuildContext context) {
    final svgState = ref.watch(svgViewModelProvider);
    final selectedId = svgState.selectedId;

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
                    'Bal Raktár',
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
                  BalRaktarSvg(),
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
