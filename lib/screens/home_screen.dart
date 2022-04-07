import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/services/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trabajadorService = Provider.of<TrabajadorService>(context);
    final socketService = Provider.of<SocketService>(context);
    final productService = Provider.of<ProductService>(context);

    if (trabajadorService.isLoading) {
      socketService.socket.emit('mensaje-nuevo', 'mensaje');
      productService.products.forEach((element) {
        socketService.socket.emit('add-product', {
          "name": element.name,
          "estante": element.estante,
          "valda": element.valda,
          "stock": element.stock,
          "rfidTag": element.rfidTag,
          "id": element.id
        });
      });
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
                  socketService.socket.on('mqtt-mensaje', (value) {
                    if (trabajadorService.trabajadores[index].rfidTag ==
                        value.toString()) {
                      trabajadorService.trabajadores[index].trabajando = true;
                      trabajadorService.updateState();
                    }
                  });
                  return GestureDetector(
                    child: _CustomContainer(
                      workerName: trabajadorService.trabajadores[index].name,
                      trabajadorService: trabajadorService,
                      tagRfid: trabajadorService.trabajadores[index].rfidTag,
                      workerStatus:
                          trabajadorService.trabajadores[index].trabajando,
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
              color: '', name: '', trabajando: false, id: null, rfidTag: "");
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
  final bool workerStatus;
  final trabajadorService;
  const _CustomContainer(
      {Key? key,
      required this.workerName,
      required this.trabajadorService,
      required this.tagRfid,
      required this.workerStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            ClipRRect(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: const Image(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/lpro-6c2f9.appspot.com/o/4b6473aa-670d-4ce0-891a-20e8a3e22107.jpg?alt=media&token=7ae5d219-c646-4e86-9c45-01b5e95014a2'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 120,
                height: 30,
                color: Colors.white12,
                child: Column(
                  children: [
                    Text(
                      workerName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      tagRfid,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 5,
              child: _CustomCircle(
                workerStatus: workerStatus,
              ),
            )
          ],
        ),
        decoration: _cardBorders(),
      ),
    );
  }
}

class _CustomCircle extends StatelessWidget {
  final workerStatus;
  const _CustomCircle({
    Key? key,
    required this.workerStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return workerStatus
        ? Icon(
            Icons.circle,
            color: Colors.green,
          )
        : Icon(
            Icons.circle,
            color: Colors.red,
          );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]);
