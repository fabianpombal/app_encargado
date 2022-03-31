import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/providers/Trabajador_form_provider.dart';
import 'package:frontend/services/trabajador_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class TrabajadorFormScreen extends StatelessWidget {
  const TrabajadorFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trabajadorServ = Provider.of<TrabajadorService>(context);

    return ChangeNotifierProvider(
      create: (context) =>
          TrabajadorFormProvider(trabajadorServ.trabajadorSeleccionado),
      child: _FormScreen(
        trabajadorService: trabajadorServ,
      ),
    );
    // return _FormScreen();
  }
}

class _FormScreen extends StatelessWidget {
  const _FormScreen({
    Key? key,
    required this.trabajadorService,
  }) : super(key: key);
  final TrabajadorService trabajadorService;

  @override
  Widget build(BuildContext context) {
    final trabajadorForm = Provider.of<TrabajadorFormProvider>(context);
    trabajadorService.trabajadorSeleccionado =
        new Trabajador(color: '', name: '', pasillo: 0, rfidTag: "");
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: trabajadorForm.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Fulanito de Tal', labelText: 'Nombre'),
                    onChanged: (value) {
                      trabajadorForm.trabajador.name = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: '1', labelText: 'Pasillo'),
                    onChanged: (value) {
                      if (int.tryParse(value) == null) {
                        return;
                      } else {
                        trabajadorForm.trabajador.pasillo = int.parse(value);
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return "el pasillo es obligatorio";
                      } else if (int.tryParse(value) == null) {
                        return "introduce un pasillo valido";
                      } else if (int.parse(value) == 0) {
                        return "el pasillo tiene que ser diferente de 0";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlockPicker(
                    pickerColor: Colors.red,
                    onColorChanged: (color) {
                      print(
                          "R:${color.red}, G: ${color.green}, B: ${color.blue}");
                      trabajadorForm.trabajador.color =
                          "${color.red},${color.green},${color.blue}";
                      return;
                    },
                    availableColors: [
                      Colors.red,
                      Colors.green,
                      Colors.black,
                      Colors.blue,
                      Colors.indigo,
                      Colors.teal
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      trabajadorService
                          .saveOrCreateTrabajador(trabajadorForm.trabajador);

                      // print(trabajadorForm.trabajador.color);
                      Navigator.pop(context);
                    },
                    color: Colors.indigo,
                    child: Text('Enviar'),
                  )
                ],
              ),
            ),
          )),
          Positioned(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            top: 15,
            left: 19,
          )
        ],
      ),
    );
  }
}
