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

    return Container(
      child: const Center(child: Text('Contenido')),
    );
  }
}
