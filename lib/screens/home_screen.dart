import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:frontend/models/models.dart';
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
              width: double.infinity,
              child: GridView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: _CustomContainer(
                      workerName: trabajadorService.trabajadores[index].name,
                      trabajadorService: trabajadorService,
                      tagRfid: trabajadorService.trabajadores[index].rfidTag,
                    ),
                    onTap: () {
                      trabajadorService.trabajadorSeleccionado =
                          trabajadorService.trabajadores[index].copy();
                      Navigator.pushNamed(context, 'worker');
                    },
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: trabajadorService.trabajadores.length,
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          trabajadorService.trabajadores.forEach((element) {
            print(element.id);
          });
          trabajadorService.trabajadorSeleccionado = new Trabajador(
              color: '', name: '', pasillo: 0, id: null, rfidTag: "");
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
  final String tagRfid;
  final trabajadorService;
  const _CustomContainer(
      {Key? key,
      required this.workerName,
      required this.trabajadorService,
      required this.tagRfid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 40,
        height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              workerName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
              tagRfid,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
        decoration: _cardBorders(),
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]);
