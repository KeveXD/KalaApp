import 'package:flutter/material.dart';
import '../constants.dart';

class TalcaWidget extends StatelessWidget {
  final List<TalcaItem> items;

  const TalcaWidget({Key? key, required this.items}) : assert(items.length >= 1 && items.length <= 5,
  'A tálcán 1 és 5 közötti ikon lehet!'), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: drawerBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) => IconButton(
          icon: Icon(item.icon, color: iconColor),
          onPressed: item.onTap,
        )).toList(),
      ),
    );
  }
}

class TalcaItem {
  final IconData icon;
  final VoidCallback onTap;

  TalcaItem({required this.icon, required this.onTap});
}
