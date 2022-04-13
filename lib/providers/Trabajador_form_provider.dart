import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:provider/provider.dart';

class TrabajadorFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Trabajador trabajador;

  TrabajadorFormProvider(this.trabajador);

  bool isValidForm() {
    print("Nombre: ${trabajador.name}");
    print("Color: ${trabajador.color}");

    return true;
  }
}
