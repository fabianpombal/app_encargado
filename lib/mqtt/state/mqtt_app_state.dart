import 'package:flutter/material.dart';

enum AppConnectionState { connected, disconnected, connecting }

class MqttAppConnectionState with ChangeNotifier {
  AppConnectionState _appConnectionState = AppConnectionState.disconnected;
  String _receivedText = "";
  final List<String> _historyText = [];

  void setReceivedText(String a) {
    _receivedText = a;
    _historyText.add(_receivedText);
    notifyListeners();
  }

  void setAppConnectionState(AppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  String get receivedText => _receivedText;
  List<String> get historyText => _historyText;
  AppConnectionState get appConnectionState => _appConnectionState;
}
