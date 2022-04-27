import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/providers/Trabajador_form_provider.dart';
import 'package:frontend/services/trabajador_service.dart';

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

class _FormScreen extends StatefulWidget {
  const _FormScreen({
    Key? key,
    required this.trabajadorService,
  }) : super(key: key);
  final TrabajadorService trabajadorService;

  @override
  State<_FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<_FormScreen> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trabajadorForm = Provider.of<TrabajadorFormProvider>(context);

    widget.trabajadorService.trabajadorSeleccionado = Trabajador(
        color: '', name: '', trabajando: false, rfidTag: "", pedidos: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Trabajador"),
      ),
      body: Center(
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
                decoration: const InputDecoration(
                    hintText: 'Fulanito de Tal', labelText: 'Nombre'),
                onChanged: (value) {
                  trabajadorForm.trabajador.name = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: '89712932', labelText: 'Tag RFID'),
                onChanged: (value) {
                  trabajadorForm.trabajador.rfidTag = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              BlockPicker(
                pickerColor: widget.trabajadorService.color1,
                onColorChanged: (color) {
                  print("R:${color.red}, G: ${color.green}, B: ${color.blue}");
                  // if (color == widget.trabajadorService.color1) {
                  //   print("LOS COLORES SON IGUALES");
                  // }
                  trabajadorForm.trabajador.color =
                      "${color.red},${color.green},${color.blue}";
                  return;
                },
                availableColors: [
                  widget.trabajadorService.color1,
                  widget.trabajadorService.color2,
                  widget.trabajadorService.color3,
                  widget.trabajadorService.color4,
                  widget.trabajadorService.color5,
                  widget.trabajadorService.color6,
                  widget.trabajadorService.color7,
                  widget.trabajadorService.color8
                ],
              ),
              MaterialButton(
                onPressed: () async {
                  final res = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ['png', 'jpg']);
                  if (res == null) return;
                  setState(() {
                    pickedFile = res.files.first;
                  });
                },
                child: const Text(
                  'Seleccionar foto',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.indigo,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 400,
                child: pickedFile == null
                    ? const Text('No image yet')
                    : Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () async {
                  if (pickedFile == null) return;
                  final path = 'trabajadores/${pickedFile!.name}';
                  final file = File(pickedFile!.path!);
                  final ref = FirebaseStorage.instance.ref(path);

                  uploadTask = ref.putFile(file);
                  final snapshot = await uploadTask!.whenComplete(() {});
                  final urlDownload = await snapshot.ref.getDownloadURL();
                  print(urlDownload);
                  trabajadorForm.trabajador.picture = urlDownload;

                  widget.trabajadorService
                      .saveOrCreateTrabajador(trabajadorForm.trabajador);

                  // print(trabajadorForm.trabajador.color);
                  Navigator.pop(context);
                },
                color: Colors.indigo,
                child: const Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
