import 'package:flutter/material.dart';
import 'package:kalaapp/utils/elem_model.dart';

import '../constants.dart';
import '../utils/eszkoz_model.dart';

class MenuTablet extends StatefulWidget {
  const MenuTablet({Key? key}) : super(key: key);

  @override
  State<MenuTablet> createState() => _MenuTabletState();
}

class _MenuTabletState extends State<MenuTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            AspectRatio(
              aspectRatio: 4,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return EszkozModel();
                  },
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 6,
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
