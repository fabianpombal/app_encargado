import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/themes/input_decorations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final trabajadores = <String>[
      'Manuel Segade',
      'Fabian Pombal',
      'Ruben Blanco',
      'Pablo Perez',
      'Eloy Rodriguez',
      'Manuel Caeiro',
      'Fernando Machado'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReadyForId'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: double.infinity,
                width: size.width * 0.4,
                child: GridView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _CustomContainer(workerName: trabajadores[index]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: trabajadores.length,
                )),
            Container(
              height: double.infinity,
              width: size.width * 0.6,
              child: Form(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        obscureText: false,
                        onChanged: (value) {
                          print(value);
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            hint: 'Fulanito Mengano',
                            label: 'Nombre del trabajador',
                            icono: Icons.person_add),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autocorrect: false,
                        obscureText: false,
                        onChanged: (value) {
                          print(value);
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecorations.authInputDecoration(
                            hint: '',
                            label: 'Pasillo del encargado',
                            icono: Icons.add_business_rounded),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Escoge el color del operario'),
                      BlockPicker(
                        pickerColor: Colors.red,
                        onColorChanged: (value) {
                          print(
                              'R: ${value.red}, G: ${value.green}, B: ${value.blue}');
                        },
                        availableColors: [
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                          Colors.deepPurple,
                          Colors.orange
                        ],
                      )
                    ],
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomContainer extends StatelessWidget {
  final String workerName;
  const _CustomContainer({Key? key, required this.workerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, 'worker'),
          child: Text(workerName),
        ),
      ),
    );
  }
}
