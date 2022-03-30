import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class TrabajadorFormScreen extends StatelessWidget {
  const TrabajadorFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Form(
            child: Column(
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: Text('MQTT publicar mensaje'),
                )
              ],
            ),
          )),
          Positioned(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            top: 15,
            left: 19,
          )
        ],
      ),
    );
  }
}
