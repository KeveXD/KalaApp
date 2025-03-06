import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // A webes fájlokhoz szükséges

Uint8List? _webImage; // Webes kép tárolása




class NewEszkoz extends StatefulWidget {
  @override
  _NewEszkozState createState() => _NewEszkozState();
}

class _NewEszkozState extends State<NewEszkoz> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _webImage = result.files.first.bytes; // Weben az adat bytes formátumban jön
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: defaultBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Új eszköz hozzáadása", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor)),
            const SizedBox(height: 10),
            _buildTextField("Eszköz azonosító *", _idController, true, Colors.red),
            _buildTextField("Lokáció", _locationController, true),
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
                    if (_idController.text.isNotEmpty) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            )
          ],
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
