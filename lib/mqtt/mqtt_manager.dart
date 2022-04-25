import 'package:frontend/mqtt/state/mqtt_app_state.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttManager {
  final MqttAppConnectionState _currentState;
  MqttClient? _client;
  final String _id;
  final String _host;
  final String _topic;
  MqttManager(
      {required String host,
      required String topic,
      required String id,
      required MqttAppConnectionState state})
      : _id = id,
        _host = host,
        _topic = topic,
        _currentState = state;

  void initializeMqttClient() {
    _client = MqttClient(_host, _id);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnect;
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier(_id)
        .withWillTopic('willTopic')
        .withWillMessage('my will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE: Connecting...');
    _client!.connectionMessage = connectMessage;
  }

  void connect() async {
    try {
      print('connecting...');
      _currentState.setAppConnectionState(AppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e) {
      print("EXception: $e");
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void onSubscribed(String topic) {
    print('Suscribed to $topic');
  }

  void onConnected() {
    _currentState.setAppConnectionState(AppConnectionState.connected);
    print("Connected");
    _client!.subscribe(_topic, MqttQos.atLeastOnce);
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> e) {
      final MqttPublishMessage recMess = e[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(pt);
    });
  }

  void onDisconnect() {
    if (_client!.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('callback disconnect');
    }
    _currentState.setAppConnectionState(AppConnectionState.disconnected);
  }
}
