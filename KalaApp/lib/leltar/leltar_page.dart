// ignore: deprecated_import
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/raktarak/new_eszkoz_dialog.dart';
import '../constants.dart';
import '../raktarak/eszkoz_viewmodel.dart';
import '../widgets/profil_widget.dart';
import '../widgets/raktarak/raktar_widget.dart';
import '../models/eszkoz_model.dart';

class LeltarPage extends ConsumerStatefulWidget {
  const LeltarPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LeltarPage> createState() => _LeltarPageState();
}

class _LeltarPageState extends ConsumerState<LeltarPage> {
  html.VideoElement? _videoElement;
  final TextEditingController _barcodeController = TextEditingController();
  bool _isCameraOpen = false;

  @override
  void dispose() {
    _stopCamera();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _toggleCamera() async {
    if (_isCameraOpen) {
      _stopCamera();
    } else {
      await _openCamera();
    }
    setState(() {
      _isCameraOpen = !_isCameraOpen;
    });
  }

  void _stopCamera() {
    _videoElement?.srcObject?.getTracks().forEach((track) => track.stop());
    final container = html.document.getElementById('cameraContainer');
    container?.children.clear();
    _videoElement = null;
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

  void _handleInventory() {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kérlek add meg a vonalkódot!')),
      );
      return;
    }

    final eszkozok = ref.read(eszkozViewModelProvider).eszkozok;
    final talalat = eszkozok.where((e) => e.eszkozAzonosito == barcode).firstOrNull;


    if (talalat != null) {

      showNewEszkozDialog(context, ref, existingEszkoz: talalat, isLeltar: true);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Hiba"),
          content: const Text("Nincs ilyen azonosítójú eszköz!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
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
            myDrawer,
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                      ),
                      onPressed: _toggleCamera,
                      icon: Icon(_isCameraOpen ? Icons.close : Icons.camera_alt),
                      label: Text(_isCameraOpen ? 'Kamera leállítása' : 'Kamera megnyitása'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kameranézet:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                      height: 400,
                      child: HtmlElementView(viewType: 'camera-container'),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: TextField(
                        controller: _barcodeController,
                        decoration: InputDecoration(
                          labelText: 'Vonalkód megadása',
                          filled: true,
                          fillColor: inputFieldColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: inputBorderColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _handleInventory,
                      child: const Text('Leltározás'),
                    ),
                  ],
                ),
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

void registerCameraContainer() {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'camera-container',
        (int viewId) => html.DivElement()..id = 'cameraContainer',
  );
}
