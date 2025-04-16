// leltar_page.dart

// ignore: deprecated_import
import 'dart:html' as html;            // DOM elemekhez
import 'dart:ui' as ui;                // platformViewRegistry-hez
import 'package:flutter/material.dart';

/// Regisztráljuk a <div id="cameraContainer"> elemet,
/// amit később a HtmlElementView ki tud helyezni.
void registerCameraContainer() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'camera-container',
        (int viewId) => html.DivElement()..id = 'cameraContainer',
  );
}

class LeltarPage extends StatefulWidget {
  const LeltarPage({Key? key}) : super(key: key);
  @override
  State<LeltarPage> createState() => _LeltarPageState();
}

class _LeltarPageState extends State<LeltarPage> {
  html.VideoElement? _videoElement;

  Future<void> _openCamera() async {
    // létrehozunk egy <video> elemet
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..setAttribute('playsinline', '')    // iOS Safari miatt
      ..style.width = '100%'
      ..style.height = '100%';

    try {
      // egyszerűsített getUserMedia hívás
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true});
      _videoElement!.srcObject = stream as html.MediaStream;

      // beillesztjük a regisztrált <div>-be
      final container = html.document.getElementById('cameraContainer');
      container
        ?..children.clear()
        ..append(_videoElement!);
    } catch (e) {
      debugPrint('Kamera elérés sikertelen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem sikerült megnyitni a kamerát')),
      );
    }
  }

  @override
  void dispose() {
    // stream leállítása kilépéskor
    _videoElement?.srcObject?.getTracks().forEach((t) => t.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leltár oldal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _openCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Kamera megnyitása'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kameranézet:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Ide kerül be a <div id="cameraContainer">
            const SizedBox(
              height: 400,
              child: HtmlElementView(viewType: 'camera-container'),
            ),
          ],
        ),
      ),
    );
  }
}
