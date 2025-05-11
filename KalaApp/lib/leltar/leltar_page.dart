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
    html.document.getElementById('cameraContainer')?.children.clear();
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
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem sikerült megnyitni a kamerát')),
      );
    }
  }


  List<EszkozModel> _szurtEszkozok(bool leltarozva) {
    final eszkozok = ref.watch(eszkozViewModelProvider).eszkozok;
    final today = DateTime.now();
    return eszkozok.where((eszkoz) {
      final leltarok = eszkoz.leltarozasok;
      final vanMa = leltarok.any((l) {
        final datum = DateTime.tryParse(l.datum);
        return datum != null &&
            datum.year == today.year &&
            datum.month == today.month &&
            datum.day == today.day;
      });
      return leltarozva ? vanMa : !vanMa;
    }).toList();
  }

  Widget _buildEszkozCard(EszkozModel eszkoz, {bool clickable = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        title: Text(eszkoz.eszkozNev, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Azonosító: ${eszkoz.eszkozAzonosito}"),
        trailing: const Icon(Icons.qr_code),
        onTap: clickable
            ? () => showNewEszkozDialog(
          context,
          ref,
          existingEszkoz: eszkoz,
          isLeltar: true,
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nemLeltarozottEszkozok = _szurtEszkozok(false);
    final leltarozottEszkozok = _szurtEszkozok(true);

    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myDrawer,
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Column(
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Eszközök (nincs ma leltározva):',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Scrollbar(
                                  child: ListView.builder(
                                    itemCount: nemLeltarozottEszkozok.length,
                                    itemBuilder: (context, index) => _buildEszkozCard(
                                      nemLeltarozottEszkozok[index],
                                      clickable: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Eszközök (ma már leltározva):',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Scrollbar(
                                  child: ListView.builder(
                                    itemCount: leltarozottEszkozok.length,
                                    itemBuilder: (context, index) => _buildEszkozCard(
                                      leltarozottEszkozok[index],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
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
