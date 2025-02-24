import 'package:flutter/material.dart';
import 'package:kalaapp/utils/my_drawer.dart';

var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[300];
var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: Text(' '),
  centerTitle: false,
);
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var myDrawer = MyDrawer();
