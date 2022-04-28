import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/mqtt/state/MQTTAppState.dart';
import 'package:frontend/services/services.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  // Private instance of client
  final MQTTAppState state;
  MqttServerClient? _client;
  final TrabajadorService? trabajadorService;
  final ProductService? productService;
  final PedidosService? pedidoService;
  final String id;
  final String host;

  final String topic;

  // Constructor
  // ignore: sort_constructors_first
  MQTTManager({
    this.productService,
    this.trabajadorService,
    this.pedidoService,
    required this.state,
    required this.id,
    required this.host,
    required this.topic,
  });

  initializeMQTTClient() {
    _client = MqttServerClient(host, id);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.disconnectOnNoResponsePeriod = 10;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(id)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    // print('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    try {
      // print('EXAMPLE::Mosquitto start client connecting....');
      state.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception {
      // print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message, String? topicFun) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (topicFun == null) {
      _client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    } else {
      _client!.publishMessage(topicFun, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    // print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    // print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      // print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    state.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    state.setAppConnectionState(MQTTAppConnectionState.connected);
    // print('EXAMPLE::Mosquitto client connected....');
    List<Producto> listaProductos = [];
    // _client!.subscribe(topic, MqttQos.atLeastOnce);
    _client!.subscribe('producto_leido', MqttQos.exactlyOnce);
    _client!.subscribe('pedir_pedido', MqttQos.exactlyOnce);
    _client!.subscribe('operario_id', MqttQos.exactlyOnce);
    _client!.subscribe('nuevo_pedido', MqttQos.exactlyOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // ignore: avoid_as
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

      // final MqttPublishMessage recMess = c![0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      state.setReceivedText(pt, c[0].topic);

      if (c[0].topic == 'operario_id') {
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        for (var trabajador in trabajadorService!.trabajadores) {
          // // print(
          // "trabajador ID: ${trabajador.rfidTag} -- mensaje recivido: $pt ");
          if (trabajador.rfidTag == pt) {
            if (trabajador.trabajando) {
              trabajador.trabajando = false;
              _client!.publishMessage('operario', MqttQos.exactlyOnce,
                  builder.addString('operario_off').payload!);
            } else {
              trabajador.trabajando = true;
              _client!.publishMessage('operario', MqttQos.exactlyOnce,
                  builder.addString('operario_on').payload!);
            }
            // print(
            // 'ACT TRABAJADOR:: topic is <${c[0].topic}>, payload is <-- $pt -->');

            trabajadorService!.saveOrCreateTrabajador(trabajador);
          }
        }
      } else if (c[0].topic == 'producto_leido') {
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
        final List<String> prodTrabajador = pt.split(',');

        Color? colorTrabajador;

        for (var trabajador in trabajadorService!.trabajadores) {
          if (trabajador.rfidTag == prodTrabajador[1]) {
            int r = int.parse(trabajador.color.split(",")[0]);
            int g = int.parse(trabajador.color.split(",")[1]);
            int b = int.parse(trabajador.color.split(",")[2]);
            colorTrabajador = Color.fromRGBO(r, g, b, 1);
            // print(
            // "color trabajador : ${colorTrabajador.toString()} -- COLOR1 : ${trabajadorService?.color1.toString()}");
          }
        }

        for (var producto in productService!.products) {
          if (producto.rfidTag == prodTrabajador[0]) {
            if (colorTrabajador.toString() ==
                trabajadorService?.color1.toString()) {
              builder.addString('${0},${1}');
              print("color trabajador : ${1}");
            } else if (colorTrabajador == trabajadorService!.color2) {
              builder.addString('${0},${2}');
              print("color trabajador : ${2}");
            } else if (colorTrabajador == trabajadorService!.color3) {
              builder.addString('${0},${3}');
              print("color trabajador : ${3}");
            } else if (colorTrabajador == trabajadorService!.color4) {
              builder.addString('${0},${4}');
              print("color trabajador : ${4}");
            } else if (colorTrabajador == trabajadorService!.color5) {
              builder.addString('${0},${5}');
              print("color trabajador : ${5}");
            } else if (colorTrabajador == trabajadorService!.color6) {
              builder.addString('${0},${6}');
              print("color trabajador : ${6}");
            } else if (colorTrabajador == trabajadorService!.color7) {
              builder.addString('${0},${7}');
              print("color trabajador : ${7}");
            } else if (colorTrabajador == trabajadorService!.color8) {
              builder.addString('${0},${8}');
              print("color trabajador : ${8}");
            }
            _client!.publishMessage(
                'leds/off', MqttQos.exactlyOnce, builder.payload!);
          }
        }
      } else if (c[0].topic == 'nuevo_pedido') {
        Trabajador trabajadorSeleccionado = trabajadorService!.trabajadores[0];
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

        if (pt == 'fin-pedido') {
          for (var trabajador in trabajadorService!.trabajadores) {
            if (!trabajador.trabajando) {
            } else if (trabajadorSeleccionado.pedidos > trabajador.pedidos) {
              trabajadorSeleccionado = trabajador;
            }
          }
          trabajadorSeleccionado.pedidos += 1;
          trabajadorService!.saveOrCreateTrabajador(trabajadorSeleccionado);
          pedidoService!
              .createPedido(listaProductos, trabajadorSeleccionado.rfidTag);
          builder.addString(listaProductos.toString());
          _client!.publishMessage('fin', MqttQos.exactlyOnce, builder.payload!);
          listaProductos.clear();
        } else {
          // print(Producto.fromJson(pt).toJson());
          listaProductos.add(Producto.fromJson(pt));
          // print("lista de prods: ${listaProductos.length}");
        }
      } else if (c[0].topic == 'pedir_pedido') {
        List<String> nombresProds = [];
        final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

        for (var pedido in pedidoService!.allPedidos) {
          if (!pedido.completed) {
            if (pedido.trabajadorId == pt) {
              List<String> idProds = pedido.productos.split(',');
              for (var idProducto in idProds) {
                for (var producto in productService!.products) {
                  if (producto.rfidTag == idProducto) {
                    nombresProds.add(producto.name);
                  }
                }
              }
              nombresProds.add('fin');
              builder.addString(nombresProds.join(':'));

              _client!.publishMessage(
                  'pedido_recibido', MqttQos.exactlyOnce, builder.payload!);
            }
          }
        }
      }
    });
    // print(
    // 'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
