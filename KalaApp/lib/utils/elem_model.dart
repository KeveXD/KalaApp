import 'package:flutter/material.dart';

class ElemModel extends StatelessWidget {
  const ElemModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 78,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
      ),
    );
  }
}
