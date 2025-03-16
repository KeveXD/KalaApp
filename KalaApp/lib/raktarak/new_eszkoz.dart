import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Csak ezt használd!
import 'dart:typed_data'; // Webes fájlokhoz szükséges
import '../constants.dart';
import 'eszkoz_view_model.dart';

Uint8List? _webImage; // Webes kép tárolása

class NewEszkoz extends ConsumerWidget {  // Átírás ConsumerWidget-re
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // Eszköz neve
  final TextEditingController _responsibleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? _selectedLocation;
  File? _image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Átadtuk a WidgetRef-ot
    final state = ref.watch(eszkozViewModelProvider); // ref.watch()

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
              _buildTextField("Eszköz neve *", _nameController, true, Colors.red),
              _buildTextField("Eszköz azonosító *", _idController, true, Colors.red),
              _buildDropdownField("Lokáció", state.raktarakNevei),
              _buildTextField("Felelős neve", _responsibleController, false),
              _buildTextField("Megjegyzés", _commentController, false, null, 3),
              const SizedBox(height: 10),
              _webImage != null
                  ? Image.memory(_webImage!, height: 100) // Webes kép
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
                      // Csak az első két mezőt ellenőrizzük
                      if (_idController.text.isNotEmpty && _nameController.text.isNotEmpty) {
                        ref.read(eszkozViewModelProvider.notifier).addNewEszkoz(
                          eszkozAzonosito: _idController.text,
                          eszkozNev: _nameController.text,
                          location: _selectedLocation ?? '',  // Ha nem választottunk lokációt, üres string
                          felelosNev: _responsibleController.text,
                          comment: _commentController.text,
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Kötelező kitölteni a kötelező mezőket!"),
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
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: options.isEmpty // Ellenőrizd, hogy a lista nem üres
          ? CircularProgressIndicator()  // Ha üres, mutass egy töltést
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
          _selectedLocation = newValue; // Az állapot itt változik
        },
      ),
    );
  }


  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      _webImage = result.files.first.bytes; // Webes adat
    }
  }
}

void showNewEszkozDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: NewEszkoz(),
      ),
    ),
  );
}
