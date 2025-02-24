import 'package:flutter/material.dart';
import 'package:kalaapp/utils/my_drawer.dart';

// Alapszínek
var defaultBackgroundColor = Colors.grey[300] ?? Colors.grey[200]!;
var appBarColor = Colors.grey[300] ?? Colors.grey[200]!;
var drawerBackgroundColor = Colors.grey[300] ?? Colors.grey[200]!;

// Szövegszínek
var drawerTextColor = TextStyle(color: Colors.grey[600] ?? Colors.grey[500]!);
var primaryTextColor = Colors.black87;
var secondaryTextColor = Colors.grey[700] ?? Colors.grey[600]!;

// Gombszínek
var buttonColor = Colors.blueGrey;
var buttonTextColor = Colors.white;

// Bemeneti mezők színei
var inputFieldColor = Colors.white;
var inputBorderColor = Colors.grey[500] ?? Colors.grey[400]!;

// Kártyaszínek (pl. bejelentkezési dobozhoz)
var cardBackgroundColor = Colors.white;
var cardShadowColor = Colors.grey[500] ?? Colors.grey[400]!;

// Listaelemek háttérszíne
var listItemColor = Colors.grey[200] ?? Colors.grey[100]!;

// Ikonok színei
var iconColor = Colors.black54;

// Padding és térközök (egységes használathoz)
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

// AppBar definiálása a globális színpalettával
var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: const Text(' '),
  centerTitle: false,
);

// Drawer létrehozása a megfelelő színnel
var myDrawer = MyDrawer();
