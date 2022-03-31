import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/models.dart';

class PedidosService extends ChangeNotifier {
  final String _baseUrl =
      'lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app';

  bool isLoading = true;

  final List<Pedido> pedidos = [];

  PedidosService() {
    this.loadPedidos();
  }

  Future<List<Pedido>> loadPedidos() async {
    notifyListeners();
    final url = Uri.https(_baseUrl, '/pedidos.json');
    final res = await http.get(url);
    final Map<String, dynamic> pedidosMap = json.decode(res.body);
    pedidosMap.forEach((key, value) {
      final tempPedidos = Pedido.fromMap(value);
      tempPedidos.id = key;
      this.pedidos.add(tempPedidos);
    });
    isLoading = true;
    notifyListeners();
    return this.pedidos;
  }
}
