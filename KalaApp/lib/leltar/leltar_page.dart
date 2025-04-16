// ignore: deprecated_import
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants.dart'; // A színpaletta
import '../widgets/profil_widget.dart';
import '../widgets/raktarak/raktar_widget.dart';

class LeltarPage extends StatefulWidget {
  const LeltarPage({Key? key}) : super(key: key);

  @override
  State<LeltarPage> createState() => _LeltarPageState();
}

class _LeltarPageState extends State<LeltarPage> {
  html.VideoElement? _videoElement;

  @override
  void dispose() {
    _videoElement?.srcObject?.getTracks().forEach((track) => track.stop());
    super.dispose();
  }

  Future<void> _openCamera() async {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..setAttribute('playsinline', '')
      ..style.width = '100%'
      ..style.height = '100%';

    try {
      final stream = await html.window.navigator.mediaDevices!
          .getUserMedia({'video': true});
      _videoElement!.srcObject = stream as html.MediaStream;

      final container = html.document.getElementById('cameraContainer');
      container
        ?..children.clear()
        ..append(_videoElement!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem sikerült megnyitni a kamerát')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myDrawer, // Oldalsó menü

            Expanded(
              flex: 2,
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
                  const SizedBox(
                    height: 400,
                    child: HtmlElementView(viewType: 'camera-container'),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  ProfilWidget(),
                  SizedBox(height: 16),
                  RaktarWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ezt a main() fájlban kell meghívni futás előtt
void registerCameraContainer() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'camera-container',
        (int viewId) => html.DivElement()..id = 'cameraContainer',
  );
}
