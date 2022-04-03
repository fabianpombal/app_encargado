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
            return ProductCard(
              idPedido: pedidoServ.pedidosActivos[index].idProducto,
              status: pedidoServ.pedidosActivos[index].estado,
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
