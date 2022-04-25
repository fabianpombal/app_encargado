import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/mqtt/mqtt_manager.dart';
import 'package:frontend/mqtt/state/mqtt_app_state.dart';
import 'package:frontend/services/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late MqttManager manager;
    final trabajadorService = Provider.of<TrabajadorService>(context);
    final mqttService = Provider.of<MqttAppConnectionState>(context);
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
                if (mqttService.appConnectionState ==
                    AppConnectionState.disconnected) {
                  manager = MqttManager(
                      host: 'broker.emqx.io',
                      topic: 'test/topic/mensaje',
                      id: 'android',
                      state: mqttService);
                  manager.initializeMqttClient();
                  manager.connect();
                }
                if (mqttService.appConnectionState ==
                    AppConnectionState.connected) {
                  manager.publish('hola de nuevo');
                }
              },
              icon: const Icon(Icons.rss_feed))
        ],
      ),
      body: Column(
        children: [
          _buildConnectionStateText(
              _prepareStateMessageFrom(mqttService.appConnectionState)),
          Center(
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    // socketService.socket.on('operario_on', (value) {
                    //   print(value);
                    //   for (var trabajador in trabajadorService.trabajadores) {
                    //     if (trabajador.rfidTag == value.toString()) {
                    //       trabajador.trabajando = true;
                    //       // trabajadorService.updateState();
                    //       trabajadorService.saveOrCreateTrabajador(trabajador);
                    //     }
                    //   }
                    // });
                    // socketService.socket.on('operario_off', (value) {
                    //   print(value);
                    //   for (var trabajador in trabajadorService.trabajadores) {
                    //     if (trabajador.rfidTag == value.toString()) {
                    //       trabajador.trabajando = false;
                    //       // trabajadorService.updateState();
                    //       trabajadorService.saveOrCreateTrabajador(trabajador);
                    //     }
                    //   }
                    // });
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: trabajadorService.trabajadores.length,
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          for (var element in trabajadorService.trabajadores) {
            print(element.id);
          }
          trabajadorService.trabajadorSeleccionado = Trabajador(
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
                decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Text(
                      trabajador.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      trabajador.rfidTag,
                      style:
                          const TextStyle(color: Colors.black26, fontSize: 14),
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
        ? const Icon(
            Icons.circle,
            color: Colors.green,
          )
        : const Icon(
            Icons.circle,
            color: Colors.red,
          );
  }
}

Widget _buildConnectionStateText(String status) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
            color: Colors.deepOrangeAccent,
            child: Text(status, textAlign: TextAlign.center)),
      ),
    ],
  );
}

String _prepareStateMessageFrom(AppConnectionState state) {
  switch (state) {
    case AppConnectionState.connected:
      return 'Connected';
    case AppConnectionState.connecting:
      return 'Connecting';
    case AppConnectionState.disconnected:
      return 'Disconnected';
  }
}

BoxDecoration _cardBorders() =>
    BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
    ]);
