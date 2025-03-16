import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart'; // Színpaletta importálása
import '../profil/profil_view_model.dart';

class ProfilWidget extends ConsumerWidget {
  final bool showBeallitasok;

  const ProfilWidget({Key? key, this.showBeallitasok = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilState = ref.watch(profilViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: cardShadowColor.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: profilState == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profilkép, ha van
                  profilState.profilePictureUrl != null
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profilState.profilePictureUrl!),
                  )
                      : Icon(Icons.person, size: 50, color: iconColor),
                  const SizedBox(height: 10),
                  Text(profilState.name, style: drawerTextColor),
                  Text(profilState.role, style: drawerTextColor),
                  const SizedBox(height: 10),
                  Text(
                    profilState.hasDebt ? "Tartozás van!" : "Nincs tartozás",
                    style: TextStyle(
                      fontSize: 14,
                      color: profilState.hasDebt ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            if (showBeallitasok)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.settings, color: iconColor),
                  onPressed: () {
                    // Navigálás beállításokhoz
                   // Navigator.push(
                   //   context,
                    //  MaterialPageRoute(builder: (context) => SettingsPage()),
                   // );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

