import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/services/trabajador_service.dart';
import 'package:frontend/themes/input_decorations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trabajadorService = Provider.of<TrabajadorService>(context);
    if (trabajadorService.isLoading) {
      return LoadingScreen();
    }

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
        child: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: double.infinity,
              width: size.width * 0.4,
              child: GridView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _CustomContainer(
                      workerName: trabajadorService.trabajadores[index].name);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: trabajadorService.trabajadores.length,
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          print(trabajadorService.trabajadores.length);
          Navigator.pushNamed(context, 'formScreen');
        },
        backgroundColor: Colors.indigo,
        elevation: 0,
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
