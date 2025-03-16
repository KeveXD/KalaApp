import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/eszkoz_model.dart'; // Feltételezve, hogy itt van az EszkozModel osztály

class EszkozWidget extends StatefulWidget {
  final EszkozModel eszkoz; // Az eszközmodell példánya

  const EszkozWidget({Key? key, required this.eszkoz}) : super(key: key);

  @override
  State<EszkozWidget> createState() => _EszkozWidgetState();
}

class _EszkozWidgetState extends State<EszkozWidget> {
  bool isExpanded = false; // Lenyitás állapota
  bool isChecked = false; // Checkbox állapota
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
                widget.eszkoz.eszkozNev, // Eszköz neve a modellből
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              subtitle: Text(
                "Nála van: ${widget.eszkoz.felelosNev}", // Akinél van az eszköz
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  IconButton(
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
                ],
              ),
            ),
          ),

          // Lenyitható rész (megjegyzések + kép lapozás)
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: inputFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Eszköz száma: ${widget.eszkoz.eszkozAzonosito}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor)),
                        Text("Eszköz neve: ${widget.eszkoz.eszkozNev}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Eszköz értéke: ${0} Ft",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Eszköz helye: ${widget.eszkoz.location}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Felelőse: ${widget.eszkoz.felelosNev}",
                            style: TextStyle(color: primaryTextColor)),
                        Text("Kinél van most: ${widget.eszkoz.felelosNev}",
                            style: TextStyle(color: primaryTextColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Megjegyzések:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: widget.eszkoz.megjegyzesek.map((megjegyzes) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: inputFieldColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Képek lapozása
                  // Képek lapozása
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: 3,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: inputBorderColor, // Placeholder szín
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.photo_camera, color: Colors.white, size: 40),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Lapozás indikátor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index ? primaryTextColor : secondaryTextColor.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Megjegyzés hozzáadása gomb
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                      ),
                      onPressed: () {
                        // Ide jöhet a megjegyzés hozzáadása funkció
                      },
                      child: const Text("Megjegyzés hozzáadása"),
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
