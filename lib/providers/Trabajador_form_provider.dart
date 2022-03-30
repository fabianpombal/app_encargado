import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:provider/provider.dart';

class TrabajadorFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Trabajador trabajador;

  TrabajadorFormProvider(this.trabajador);

  bool isValidForm() {
    print(trabajador.name);
    print(trabajador.color);
    print(trabajador.pasillo);
    return formKey.currentState?.validate() ?? false;
  }
}
