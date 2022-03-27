import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {required String hint, required String label, IconData? icono}) {
    return InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(13, 96, 254, 1), width: 3)),
        hintText: hint,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        prefixIcon: icono != null ? Icon(icono) : null);
  }
}
