import 'package:flutter/material.dart';
import 'package:kalaapp/widgets/drawer_widget.dart';

// Természetes barna és zöld árnyalatok a fenyőerdő hangulathoz
var defaultBackgroundColor = const Color(0xFFB2A68E); // Világos, meleg barna háttérszín (földszín)
var appBarColor = const Color(0xFF655849); // Sötétbarna, fenyőerdei hangulatú AppBar szín
var drawerBackgroundColor = const Color(0xFF706455); // Sötétbarna, fenyőerdei hangulatú fiók háttérszín

// Szövegszínek a természetes barna és zöld árnyalatokhoz igazítva
var drawerTextColor = const TextStyle(color: Color(0xFF3E2B1D)); // Sötétbarna szöveg a fiókban
var primaryTextColor = const Color(0xFF4A3D35); // Mélyebb barna szöveg az alkalmazás fő tartalmában
var secondaryTextColor = const Color(0xFF3E2B1D); // Barna szöveg másodlagos elemekhez

// Gombszínek (természetes, meleg barna)
var buttonColor = const Color(0xFF4E3B31); // Közepes barna gomb szín
var buttonTextColor = Colors.white; // Fehér gomb szöveg a jobb láthatóság érdekében

// Bemeneti mezők színei
var inputFieldColor = const Color(0xFFEBE3D9); // Világos krém árnyalatú bemeneti mező
var inputBorderColor = const Color(0xFF9C8C72); // Meleg, sötétbarna szegély szín

// Kártyaszínek
var cardBackgroundColor = const Color(0xFFEBE3D9); // Krémes háttér a kártyákhoz
var cardShadowColor = const Color(0xFF7A5C3F); // Sötétebb barna árnyék a kártyákhoz

// Listaelemek háttérszíne
var listItemColor = const Color(0xFF8C7D66); // Finom barna árnyalatú lista elemek háttérszíne

// Ikonok színei
var iconColor = const Color(0xFF4E3B31); // Meleg, sötétbarna ikonok

// Padding és térközök (egységes használathoz)
var tilePadding = const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0); // Néhány extra térköz az olvashatóságért

// AppBar definiálása a globális színpalettával
var myAppBar = AppBar(
  backgroundColor: appBarColor, // Sötétbarna app bar
  title: const Text(' '),
  centerTitle: false,
);

// Drawer létrehozása a megfelelő színnel
var myDrawer = DrawerWidget();
