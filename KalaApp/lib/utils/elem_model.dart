import 'package:flutter/material.dart';
import '../constants.dart';

class ElemModel extends StatefulWidget {
  const ElemModel({Key? key}) : super(key: key);

  @override
  State<ElemModel> createState() => _ElemModelState();
}

class _ElemModelState extends State<ElemModel> {
  bool isExpanded = false; // Lenyitás állapota

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          // Fő listaelem (összecsukott állapot)
          Container(
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: cardShadowColor.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: inputBorderColor, // Placeholder szín
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.white), // Placeholder ikon
              ),
              title: Text(
                "Elem neve",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              subtitle: Text(
                "Tulajdonos: Kovács Péter",
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: iconColor,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
          ),

          // Lenyitható rész (megjegyzések + térkép placeholder)
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: drawerBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Megjegyzés rész
                  Text(
                    "Megjegyzés:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ez egy példa megjegyzés az adott elemhez.",
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Térkép placeholder
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: inputBorderColor, // Placeholder szín
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.map, color: Colors.white, size: 40), // Placeholder ikon
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
