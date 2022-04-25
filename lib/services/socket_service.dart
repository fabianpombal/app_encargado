// import 'package:flutter/material.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

// enum ServerStatus { Online, Offline, Connecting }

// class SocketService with ChangeNotifier {
//   ServerStatus _serverStatus = ServerStatus.Connecting;
//   late IO.Socket _socket;

//   SocketService() {
//     _initConfig();
//   }

//   ServerStatus get serverStatus => _serverStatus;
//   IO.Socket get socket => _socket;

//   void _initConfig() {
//     _socket = IO.io(
//         'http://localhost:8001',
//         IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//             {'foo': 'bar'}).build());

//     // socket.connect();
//     _socket.clearListeners();
//     _socket.onConnect((_) {
//       print('connect');
//       _serverStatus = ServerStatus.Online;
//       socket.emit("mensaje-nuevo", "test");
//       notifyListeners();
//     });

//     _socket.onDisconnect((_) {
//       print('disconnect');
//       _serverStatus = ServerStatus.Offline;
//       notifyListeners();
//     });
//   }
// }
