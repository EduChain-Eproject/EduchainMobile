import 'package:flutter/material.dart';

class TextFieldModel {
  final String label;
  late final TextEditingController controller;
  late final String camelLabel;
  String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;

  TextFieldModel({
    required this.label,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) {
    controller = TextEditingController();
    camelLabel = _toCamelCase(label);
  }

  String _toCamelCase(String label) {
    return label
        .toLowerCase()
        .split(' ')
        .asMap()
        .map((index, word) {
          if (index == 0) {
            return MapEntry(index, word);
          } else {
            return MapEntry(index, word[0].toUpperCase() + word.substring(1));
          }
        })
        .values
        .join('');
  }
}
