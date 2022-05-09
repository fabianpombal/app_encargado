import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mqtt/state/MQTTAppState.dart';

class MqttViewMessages extends StatefulWidget {
  const MqttViewMessages({Key? key}) : super(key: key);

  @override
  State<MqttViewMessages> createState() => _MqttViewMessagesState();
}

class _MqttViewMessagesState extends State<MqttViewMessages> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MQTTAppState>(context);

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "topic: ${appState.getHistorial.keys.elementAt(index)}, mensaje:  ${appState.getHistorial.values.elementAt(index)}",
                style: const TextStyle(fontSize: 20),
              ),
            );
          },
          itemCount: appState.getHistorial.values.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Colors.black26,
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_outlined),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
    );
  }
}
