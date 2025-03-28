import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class JobbRaktarSvg extends StatefulWidget {
  @override
  _JobbRaktarSvgState createState() => _JobbRaktarSvgState();
}

class _JobbRaktarSvgState extends State<JobbRaktarSvg> {
  // Különböző részek állapota (színváltoztatás)
  Map<String, Color> sectionColors = {
    "balPolc": Colors.red,
    "jobbPolc": Colors.red,
    "balRekesz1": Colors.brown,
    "balRekesz2": Colors.brown,
    "jobbRekesz1": Colors.brown,
    "jobbRekesz2": Colors.brown,
  };

  // Kattintás kezelése
  void handleTap(String section) {
    setState(() {
      // A szürke színre változtatjuk
      sectionColors[section] = Colors.grey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(title: Text('Interactive SVG')),
      body: Center(
        child: Stack(
          children: [
            // SVG háttér
            SvgPicture.string(
              '''
              <svg width="300" height="400" xmlns="http://www.w3.org/2000/svg">
                <!-- Háttér (Szoba) -->
                <rect x="0" y="0" width="300" height="400" stroke="navy" stroke-width="2" fill="navy" />
                <!-- Bal oldali egybefüggő polc -->
                <rect x="20" y="20" width="50" height="350" stroke="red" stroke-width="2" fill="${sectionColors["balPolc"]}" id="balPolc"/>
                <!-- Jobb oldali egybefüggő polc -->
                <rect x="230" y="20" width="50" height="350" stroke="red" stroke-width="2" fill="${sectionColors["jobbPolc"]}" id="jobbPolc"/>
                <!-- Bal oldali rekeszek -->
                <rect x="30" y="30" width="30" height="60" stroke="gold" stroke-width="2" fill="${sectionColors["balRekesz1"]}" id="balRekesz1"/>
                <rect x="30" y="120" width="30" height="60" stroke="gold" stroke-width="2" fill="${sectionColors["balRekesz2"]}" id="balRekesz2"/>
                <!-- Jobb oldali rekeszek -->
                <rect x="240" y="30" width="30" height="60" stroke="gold" stroke-width="2" fill="${sectionColors["jobbRekesz1"]}" id="jobbRekesz1"/>
                <rect x="240" y="120" width="30" height="60" stroke="gold" stroke-width="2" fill="${sectionColors["jobbRekesz2"]}" id="jobbRekesz2"/>
                <!-- Tükrözött ajtó (negyedkör, befelé nyíló) -->
                <path d="M 150 380 A 40 40 0 0 1 110 340" stroke="white" stroke-width="4" fill="none" />
                <!-- Ajtó szárnya -->
                <path d="M 150 380 L 150 340" stroke="white" stroke-width="4" />
              </svg>
              ''',
              alignment: Alignment.center,
              allowDrawingOutsideViewBox: true,
            ),
            // Kattintható bal polc
            Positioned(
              left: 20,
              top: 20,
              child: GestureDetector(
                onTap: () => handleTap('balPolc'),
                child: Container(
                  width: 50,
                  height: 350,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
            // Kattintható jobb polc
            Positioned(
              left: 230,
              top: 20,
              child: GestureDetector(
                onTap: () => handleTap('jobbPolc'),
                child: Container(
                  width: 50,
                  height: 350,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
            // Kattintható bal rekeszek
            Positioned(
              left: 30,
              top: 30,
              child: GestureDetector(
                onTap: () => handleTap('balRekesz1'),
                child: Container(
                  width: 30,
                  height: 60,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
            Positioned(
              left: 30,
              top: 120,
              child: GestureDetector(
                onTap: () => handleTap('balRekesz2'),
                child: Container(
                  width: 30,
                  height: 60,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
            // Kattintható jobb rekeszek
            Positioned(
              left: 240,
              top: 30,
              child: GestureDetector(
                onTap: () => handleTap('jobbRekesz1'),
                child: Container(
                  width: 30,
                  height: 60,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
            Positioned(
              left: 240,
              top: 120,
              child: GestureDetector(
                onTap: () => handleTap('jobbRekesz2'),
                child: Container(
                  width: 30,
                  height: 60,
                  color: Colors.transparent,  // Átlátszó, de mégis érzékeli a kattintást
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
