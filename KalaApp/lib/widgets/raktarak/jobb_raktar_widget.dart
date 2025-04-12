import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalaapp/svg/jobb_raktar_svg.dart';

import '../../constants.dart';
import '../../svg/svg_viewmodel.dart';

class JobbRaktarWidget extends ConsumerStatefulWidget {
  const JobbRaktarWidget({Key? key}) : super(key: key);

  @override
  _JobbRaktarWidgetState createState() => _JobbRaktarWidgetState();
}

class _JobbRaktarWidgetState extends ConsumerState<JobbRaktarWidget> {
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
                    'Jobb Raktár',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔽 Itt jelenítjük meg a kiválasztott csempét
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
                  JobbRaktarSvg(),
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
