import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/models/eszkoz_model.dart';
import 'dart:typed_data';
import '../constants.dart';
import '../svg/svg_viewmodel.dart';
import '../widgets/raktarak/jobb_raktar_widget.dart';
import 'eszkoz_view_model.dart';

Uint8List? _webImage;

class NewEszkozDialog extends ConsumerWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _locationDetailController = TextEditingController(); // ➕ ÚJ: pontos hely
  String? _selectedLocation;
  File? _image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eszkozViewModelProvider);

    final svgState = ref.watch(svgViewModelProvider);

    // Automatikusan beállítjuk a location detail-t a selectedId alapján
    if (svgState.selectedId != null && _locationDetailController.text != svgState.selectedId) {
      _locationDetailController.text = svgState.selectedId!;
    }

    return Dialog(
      backgroundColor: defaultBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Új eszköz hozzáadása", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor)),
              const SizedBox(height: 10),
              _buildTextField("Eszköz neve *", _nameController, false, Colors.red),
              _buildTextField("Eszköz azonosító *", _idController, false, Colors.red),
              _buildDropdownField("Lokáció", state.raktarakNevei),

                _buildTextField("Eszköz pontos helye", _locationDetailController, true),



                Column(
                  children: const [
                    SizedBox(height: 10),
                    JobbRaktarWidget(),
                  ],
                ),

              const SizedBox(height: 10),
              _buildTextField("Érték", _valueController, true),
              _buildTextField("Felelős neve", _responsibleController, false),
              _buildTextField("Megjegyzés", _commentController, false, null, 3),

              const SizedBox(height: 10),
              _webImage != null
                  ? Image.memory(_webImage!, height: 100)
                  : Text("Nincs kiválasztott kép"),
              TextButton.icon(
                icon: Icon(Icons.image, color: iconColor),
                label: Text("Kép kiválasztása", style: TextStyle(color: primaryTextColor)),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: buttonColor),
                    child: Text("Mégse", style: TextStyle(color: buttonTextColor)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    child: Text("Hozzáadás", style: TextStyle(color: buttonTextColor)),
                    onPressed: () {
                      if (_idController.text.isNotEmpty && _nameController.text.isNotEmpty) {
                        final double? ertek = double.tryParse(_valueController.text);
                        if (ertek == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Érvényes számot adj meg az érték mezőben!"),
                          ));
                          return;
                        }

                        ref.read(eszkozViewModelProvider.notifier).addNewEszkoz(
                          EszkozModel(
                            eszkozNev: _nameController.text,
                            eszkozAzonosito: _idController.text,
                            lokacio: _selectedLocation ?? '',
                            felelosNev: _responsibleController.text,
                            komment: _commentController.text,
                            raktaronBelul: _locationDetailController.text.isNotEmpty ? int.tryParse(_locationDetailController.text) : null,
                            ertek: ertek,
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Kötelező kitölteni a csillagozott mezőket!"),
                        ));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isNumber, [Color? labelColor, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor ?? primaryTextColor),
          border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
          filled: true,
          fillColor: inputFieldColor,
        ),
        keyboardType: isNumber ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: options.isEmpty
          ? CircularProgressIndicator()
          : DropdownButtonFormField<String>(
        value: _selectedLocation,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryTextColor),
          border: OutlineInputBorder(borderSide: BorderSide(color: inputBorderColor)),
          filled: true,
          fillColor: inputFieldColor,
        ),
        items: options.map((location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(location),
          );
        }).toList(),
        onChanged: (newValue) {
          _selectedLocation = newValue;
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      _webImage = result.files.first.bytes;
    }
  }
}


void showNewEszkozDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: NewEszkozDialog(),
      ),
    ),
  );
}
