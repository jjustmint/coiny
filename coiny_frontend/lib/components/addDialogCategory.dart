import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCategoryDialog extends StatefulWidget {
  AddCategoryDialog({
    Key? key,
    required this.token,
    required this.reloadData,
  }) : super(key: key);
  final Function reloadData;
  final String token;

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedIconName = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _postCategory() async {
    try {
      final apiUrl = 'http://10.0.2.2:4000/categories/create';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'token': widget.token,
          'name': _nameController.text,
          'iconName': _selectedIconName,
        }),
      );

      if (response.statusCode == 200) {
        print('Category created successfully(200)');
        Navigator.pop(context, 'OK');
      } else {
        throw Exception('Failed to create category');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String? _validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a category name';
    }
    return null;
  }

  String? _validateIconSelection() {
    if (_selectedIconName.isEmpty) {
      return 'Please select an icon';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFEDB59E),
      title: Text('New Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 12.0, // Space between the icons
              runSpacing: 12.0, // Space between rows
              children: iconDataMap.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIconName = entry.key;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        entry.value,
                        color: _selectedIconName == entry.key
                            ? Colors.blue // Change the color when selected
                            : Colors.white,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (_validateIconSelection() != null) // Show icon validation error
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _validateIconSelection()!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 8.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ex. Movies',
                  filled: true,
                  fillColor: Color(0xFFFFF3EC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 15.0,
                  ),
                ),
                validator: _validateCategoryName,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFF5CCB4)),
                ),
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF95491E)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF95491E)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _validateIconSelection() == null) {
                    await _postCategory();
                    await widget.reloadData();
                  } else {
                    setState(
                        () {}); // Trigger re-build to show validation errors
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFEDB59E)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final Map<String, IconData> iconDataMap = {
  'music': Icons.music_note,
  'baby': Icons.child_friendly,
  'bag': Icons.business_center,
  'home': Icons.home,
  'sun': Icons.brightness_5,
  'bus': Icons.directions_bus,
  'rabbit': Icons.cruelty_free,
  'fastfood': Icons.fastfood,
  'restaurant': Icons.restaurant,
  'heart': Icons.favorite,
  'flower': Icons.local_florist,
  'gasstation': Icons.local_gas_station,
  'cart': Icons.shopping_cart,
  'localmall': Icons.local_mall,
  'cameraroll': Icons.camera_roll,
  'tag': Icons.loyalty,
  'entertain': Icons.sports_esports,
  'flag': Icons.flag,
  'fitness': Icons.fitness_center,
  'alert': Icons.crisis_alert,
  'coffee': Icons.coffee,
  'location': Icons.location_on,
  'chair': Icons.chair,
  'category': Icons.category,
  'other': Icons.more_horiz,
  // Add more mappings as needed
};
