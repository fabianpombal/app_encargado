import 'package:flutter/material.dart';
import 'package:frontend/services/producto_service.dart';
import 'package:frontend/services/trabajador_service.dart';
import 'package:provider/provider.dart';

class WorkerScreen extends StatelessWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trabajadorServ = Provider.of<TrabajadorService>(context);
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ProductService())
    ], child: _PantallaPedidos(trabajadorServ: trabajadorServ));
  }
}

class _PantallaPedidos extends StatelessWidget {
  const _PantallaPedidos({
    Key? key,
    required this.trabajadorServ,
  }) : super(key: key);

  final TrabajadorService trabajadorServ;

  @override
  Widget build(BuildContext context) {
    final prodServ = Provider.of<ProductService>(context);
    int R = 0;
    int G = 0;
    int B = 0;

    List<String> colorAux =
        trabajadorServ.trabajadorSeleccionado.color.split(",");
    R = int.parse(colorAux[0]);
    G = int.parse(colorAux[1]);
    B = int.parse(colorAux[2]);

    return Scaffold(
      appBar: AppBar(
        title: Text('${trabajadorServ.trabajadorSeleccionado.name}'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(R, G, B, 1),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Text(prodServ.products[index].name);
          },
          itemCount: prodServ.products.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          trabajadorServ.trabajadores.forEach((element) {
            print(element.id);
          });
          print(trabajadorServ.trabajadorSeleccionado.id);
        },
      ),
    );
  }
}
