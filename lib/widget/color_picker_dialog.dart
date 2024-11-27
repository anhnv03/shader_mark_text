import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void _showColorPickerDialog(
  BuildContext context, {
  required String title,
  required Color initialColor,
  required ValueChanged<Color> onColorSelected,
}) {
  Color tempColor = initialColor;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onColorSelected(tempColor);
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      );
    },
  );
}
