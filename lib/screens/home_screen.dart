import 'dart:convert';

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

    // if (trabajadorService.isLoading) {
    //   return LoadingScreen();
    // }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReadyForId'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                print("Accion");
              },
              icon: Icon(
                Icons.info,
                color: socketService.serverStatus == ServerStatus.Online
                    ? Colors.green
                    : Colors.red,
              ))
        ],
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
                  socketService.socket.on('operario_on', (value) {
                    print(value);
                    if (trabajadorService.trabajadores[index].rfidTag ==
                        value.toString()) {
                      trabajadorService.trabajadores[index].trabajando = true;
                      trabajadorService.updateState();
                    }
                  });
                  socketService.socket.on('operario_off', (value) {
                    print(value);
                    if (trabajadorService.trabajadores[index].rfidTag ==
                        value.toString()) {
                      trabajadorService.trabajadores[index].trabajando = false;
                      trabajadorService.updateState();
                    }
                  });
                  return GestureDetector(
                    child: _CustomContainer(
                      trabajador: trabajadorService.trabajadores[index],
                      trabajadorService: trabajadorService,
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
              color: '',
              name: '',
              trabajando: false,
              id: null,
              rfidTag: "",
              picture: "");
          Navigator.pushNamed(context, 'formScreen');
        },
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
    );
  }
}

class _CustomContainer extends StatelessWidget {
  final trabajadorService;
  final Trabajador trabajador;
  const _CustomContainer({
    Key? key,
    required this.trabajadorService,
    required this.trabajador,
  }) : super(key: key);
  final num = 2 + 1;

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
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: trabajador.picture != "null"
                    ? FadeInImage(
                        placeholder: const AssetImage('assets/load.gif'),
                        image: NetworkImage(trabajador.picture!),
                        fit: BoxFit.cover,
                      )
                    : const Image(
                        image: AssetImage('assets/no-image2.jpg'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 170,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Text(
                      trabajador.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      trabajador.rfidTag,
                      style: TextStyle(color: Colors.black26, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 5,
              child: _CustomCircle(
                workerStatus: trabajador.trabajando,
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

BoxDecoration _cardBorders() =>
    BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
    ]);
