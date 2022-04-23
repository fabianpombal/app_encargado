import 'package:flutter/material.dart';
import 'package:frontend/services/services.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:provider/provider.dart';

class WorkerScreen extends StatelessWidget {
  const WorkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trabajadorServ = Provider.of<TrabajadorService>(context);
    final socketService = Provider.of<SocketService>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProductService()),
          ChangeNotifierProvider(
              create: (context) =>
                  PedidosService(trabajadorServ.trabajadorSeleccionado.rfidTag))
        ],
        child: _PantallaPedidos(
          trabajadorServ: trabajadorServ,
          socketService: socketService,
        ));
  }
}

class _PantallaPedidos extends StatelessWidget {
  const _PantallaPedidos({
    Key? key,
    required this.trabajadorServ,
    required this.socketService,
  }) : super(key: key);

  final TrabajadorService trabajadorServ;
  final SocketService socketService;

  @override
  Widget build(BuildContext context) {
    final prodServ = Provider.of<ProductService>(context);
    final pedidoServ = Provider.of<PedidosService>(context);

    int R = 0;
    int G = 0;
    int B = 0;

    // final List<Pedido> pedidosAux = pedidoServ.loadPedidosByWorker(trabajadorServ.trabajadorSeleccionado.rfidTag);

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
            return GestureDetector(
              child: ProductCard(
                productosPedido: pedidoServ.pedidosActivos[index].id!,
                status: pedidoServ.pedidosActivos[index].completed,
              ),
              onTap: () {
                List<String> prods =
                    pedidoServ.pedidosActivos[index].productos.split(",");
                showDialog(
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          height: 400,
                          width: 500,
                          color: Colors.white,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Producto ${index + 1}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " - Nombre: ${prodServ.listarPorId(prods[index])!.name}",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Estante: ${prodServ.listarPorId(prods[index])!.columna.toString()}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                        "Balda: ${prodServ.listarPorId(prods[index])!.fila.toString()}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                    Text(
                                        "Tag RFID: ${prodServ.listarPorId(prods[index])!.rfidTag}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: prods.length,
                          ),
                        ),
                      );
                    },
                    context: context);
              },
            );
          },
          itemCount: pedidoServ.pedidosActivos.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit('mensaje-nuevo',
              {"id": trabajadorServ.trabajadorSeleccionado.id});
          trabajadorServ.trabajadores.forEach((element) {
            print(element.id);
          });
          print(trabajadorServ.trabajadorSeleccionado.id);
        },
      ),
    );
  }
}
