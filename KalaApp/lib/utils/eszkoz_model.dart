import 'package:flutter/material.dart';
import '../constants.dart';

class EszkozModel extends StatelessWidget {
  const EszkozModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: listItemColor,
        ),
      ),
    );
  }
}
