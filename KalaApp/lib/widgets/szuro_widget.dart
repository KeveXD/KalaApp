import 'package:flutter/material.dart';
import '../constants.dart';

class SzuroWidget extends StatelessWidget {
  final bool isFilterExpanded;
  final bool isFilterApplied;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function(bool) onToggleExpanded;
  final VoidCallback onApplyFilter;
  final Widget dropdownWidget;

  const SzuroWidget({
    Key? key,
    required this.isFilterExpanded,
    required this.isFilterApplied,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onToggleExpanded,
    required this.onApplyFilter,
    required this.dropdownWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text("Szűrés",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            trailing: IconButton(
              icon: Icon(
                isFilterExpanded ? Icons.expand_less : Icons.expand_more,
                color: iconColor,
              ),
              onPressed: () => onToggleExpanded(!isFilterExpanded),
            ),
          ),
          if (isFilterExpanded)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildStyledTextField("Keresés név szerint", Icons.search),
                  const SizedBox(height: 10),
                  dropdownWidget,
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                    ),
                    onPressed: onApplyFilter,
                    child: const Text("Szűrés alkalmazása"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField(String hintText, IconData icon) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: iconColor),
        hintText: hintText,
        filled: true,
        fillColor: inputFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputBorderColor),
        ),
      ),
    );
  }
}
