import 'package:flutter/material.dart';
import 'package:kalaapp/widgets/eszkoz_widget.dart';

import '../constants.dart';
import '../utils/elem_model.dart';

class MenuMobil extends StatefulWidget {
  const MenuMobil({Key? key}) : super(key: key);

  @override
  State<MenuMobil> createState() => _MenuMobilState();
}

class _MenuMobilState extends State<MenuMobil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(' '),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
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
            AspectRatio(
              aspectRatio: 1,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return RaktarWidget();
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ElemModel();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
