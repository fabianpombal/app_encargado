import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/models.dart';

class PedidosService extends ChangeNotifier {
  final String _baseUrl =
      'lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app';

  bool isLoading = true;
  final List<Pedido> pedidosActivos = [];

  final List<String> productosRfidTag = [];

  final Pedido pedido = Pedido(
    completed: false,
    productos: '',
    trabajadorId: '',
  );

  final List<Pedido> allPedidos = [];

  PedidosService() {
    loadPedidos();
    // loadPedidosByWorker(workerId);
  }

  Future<String> createPedido(
      List<Producto> productosFun, String tagTrabajador) async {
    List<String> listaProds = [];
    print(productosFun);

    for (var producto in productosFun) {
      listaProds.add(producto.rfidTag);
    }

    final url = Uri.https(_baseUrl, 'pedidos.json');
    pedido.productos = listaProds.join(',');
    print("----- nuevo pedido: ${listaProds.join(',')}");
    pedido.trabajadorId = tagTrabajador;
    final res = await http.post(url, body: pedido.toJson());
    final decodedData = json.decode(res.body);
    pedido.id = decodedData["name"];
    print(decodedData);
    allPedidos.add(pedido);
    notifyListeners();
    return '';
  }

  Future<List<Pedido>> loadPedidos() async {
    notifyListeners();
    final url = Uri.https(_baseUrl, 'pedidos.json');
    final res = await http.get(url);
    final Map<String, dynamic> pedidosMap = json.decode(res.body);
    pedidosMap.forEach((key, value) {
      final tempPedidos = Pedido.fromMap(value);
      tempPedidos.id = key;
      allPedidos.add(tempPedidos);
    });
    isLoading = false;
    notifyListeners();
    return allPedidos;
  }

  Future<List<Pedido>> loadPedidosByWorker(String workerId) async {
    notifyListeners();
    final Map<String, String> queryParams = {
      'orderBy': '"trabajadorId"',
      "equalTo": '"$workerId"'
    };

    final url = Uri.https(_baseUrl, '/pedidos.json', queryParams);
    print("QUERY: " + url.query);
    final res = await http.get(url);

    final Map<String, dynamic> pedidosMap = json.decode(res.body);
    pedidosMap.forEach((key, value) {
      final tempPedidos = Pedido.fromMap(value);
      tempPedidos.id = key;
      pedidosActivos.add(tempPedidos);
    });
    isLoading = false;
    notifyListeners();
    return pedidosActivos;
  }
}
