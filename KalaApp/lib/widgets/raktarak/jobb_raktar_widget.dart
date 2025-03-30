import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalaapp/svg/jobb_raktar_svg.dart';

import '../../constants.dart'; // Ha szükséges az SVG megjelenítéséhez

class JobbRaktarWidget extends StatefulWidget {
  const JobbRaktarWidget({Key? key}) : super(key: key);

  @override
  _JobbRaktarWidgetState createState() => _JobbRaktarWidgetState();
}

class _JobbRaktarWidgetState extends State<JobbRaktarWidget> {
  String selectedShelf = '0'; // Alapértelmezett polc: 0

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          // Az egész tartalom egy konténerbe kerül
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
            child: SingleChildScrollView(  // Görgethetőség engedélyezése
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Téma színű szöveg a tetején
                  Text(
                    'Jobb Raktár',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor, // Az előzőleg meghatározott szín
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SVG képet tartalmazó konténer
                  JobbRaktarSvg(),
                  const SizedBox(height: 20),

                  // Polc kiválasztó
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
                          // A gomb működése itt implementálható
                          print('Polc $selectedShelf kiválasztva');
                        },
                        child: const Text('Mehet'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: buttonTextColor, backgroundColor: buttonColor,
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
