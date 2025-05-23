import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalaapp/models/eszkoz_model.dart';
import 'dart:typed_data';
import '../constants.dart';
import '../login/login_viewmodel.dart';
import '../models/leltar_bejegyzes_model.dart';
import '../models/raktar_model.dart';
import '../svg/svg_viewmodel.dart';
import '../widgets/raktarak/raktar_widget.dart';
import '../widgets/raktarak/raktar_widget_viewmodel.dart';
import 'eszkoz_viewmodel.dart';

Uint8List? _webImage;

class NewEszkozDialog extends ConsumerStatefulWidget {
  final EszkozModel? existingEszkoz;
  final bool isLeltar;

  NewEszkozDialog({this.existingEszkoz, this.isLeltar = false, Key? key})
      : super(key: key);

  @override
  ConsumerState<NewEszkozDialog> createState() => _NewEszkozDialogState();
}

class _NewEszkozDialogState extends ConsumerState<NewEszkozDialog> {
  @override
  void initState() {
    super.initState();
  }


  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _locationDetailController = TextEditingController();
  String? _selectedLocation;
  File? _image;

  @override
  Widget build(BuildContext context) {
    final eszkozState = ref.watch(eszkozViewModelProvider);
    final raktarState = ref.watch(raktarWidgetViewModelProvider);
    final svgState = ref.watch(svgViewModelProvider);

    if (widget.existingEszkoz != null) {
      _idController.text = widget.existingEszkoz!.eszkozAzonosito;
      _nameController.text = widget.existingEszkoz!.eszkozNev;
      _responsibleController.text = widget.existingEszkoz!.felelosNev ?? '';
      _commentController.text = widget.existingEszkoz!.komment ?? '';
      _valueController.text = widget.existingEszkoz!.ertek?.toString() ?? '';
      _locationDetailController.text = widget.existingEszkoz!.raktaronBelul?.toString() ?? '';
      _selectedLocation = widget.existingEszkoz!.lokacio;
    } else if (svgState.selectedId != null && _locationDetailController.text.isEmpty) {
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
              Text(
                widget.existingEszkoz == null ? "Új eszköz hozzáadása" : "Eszköz szerkesztése",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
              ),
              const SizedBox(height: 10),
              _buildTextField("Eszköz neve *", _nameController, false, Colors.red),
              _buildTextField("Eszköz azonosító *", _idController, false, Colors.red),
              _buildRaktarDropdownField("Lokáció *", eszkozState.raktarak, ref),
              _buildTextField("Eszköz pontos helye *", _locationDetailController, true, Colors.red),
              Column(
                children: [
                  const SizedBox(height: 10),
                  RaktarWidget(),
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
                    child: Text(widget.existingEszkoz == null ? "Hozzáadás" : "Mentés", style: TextStyle(color: buttonTextColor)),
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _idController.text.isEmpty ||
                          _selectedLocation == null ||
                          _locationDetailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Kérlek töltsd ki az összes csillagozott mezőt!"),
                        ));
                        return;
                      }

                      final double? ertek = _valueController.text.isNotEmpty
                          ? double.tryParse(_valueController.text)
                          : null;

                      if (_valueController.text.isNotEmpty && ertek == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Érvényes számot adj meg az érték mezőben!"),
                        ));
                        return;
                      }

                      final newEszkoz = EszkozModel(
                        eszkozNev: _nameController.text,
                        eszkozAzonosito: _idController.text,
                        lokacio: _selectedLocation ?? '',
                        raktaronBelul: int.tryParse(_locationDetailController.text),
                        felelosNev: _responsibleController.text,
                        komment: _commentController.text,
                        ertek: ertek,
                      );
                      if (widget.isLeltar) {
                        newEszkoz.leltarozasok.add(LeltarBejegyzesModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          datum: DateTime.now().toString(),
                          felhasznaloAzonosito: ref
                              .read(loginViewModelProvider)
                              .felhasznalo!
                              .email,
                        ));
                      }
                      if (widget.existingEszkoz == null) {

                        ref.read(eszkozViewModelProvider.notifier)
                            .addNewEszkoz(newEszkoz);
                      } else {
                        ref
                            .read(eszkozViewModelProvider.notifier)
                            .updateEszkoz(widget.existingEszkoz!, newEszkoz);
                      }

                      Navigator.of(context).pop();
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

  Widget _buildRaktarDropdownField(String label, List<RaktarModel> raktarModelek, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: raktarModelek.isEmpty
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
        items: raktarModelek.map((raktar) {
          return DropdownMenuItem<String>(
            value: raktar.nev,
            child: Text(raktar.nev),
          );
        }).toList(),
        onChanged: (newValue) {
          ref.read(raktarWidgetViewModelProvider.notifier)
              .selectRaktar(raktarModelek.firstWhere((raktar) => raktar.nev == newValue));
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

void showNewEszkozDialog(BuildContext context, WidgetRef ref,
    {EszkozModel? existingEszkoz, bool isLeltar = false}) {
  if (existingEszkoz != null) {
    ref
        .read(svgViewModelProvider.notifier)
        .updateState(id: existingEszkoz.raktaronBelul.toString());
  }
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child:
        NewEszkozDialog(existingEszkoz: existingEszkoz, isLeltar: isLeltar),
      ),
    ),
  );
}
