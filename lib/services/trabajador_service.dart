import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrabajadorService extends ChangeNotifier {
  final String _baseUrl =
      'lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Trabajador> trabajadores = [];

  bool isLoading = true;
  bool isSaving = true;

  TrabajadorService() {
    this.loadTrabajadores();
  }

  Future<List<Trabajador>> loadTrabajadores() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'trabajadores.json');
    final res = await http.get(url);
    final Map<String, dynamic> trabajadoresMap = json.decode(res.body);
    trabajadoresMap.forEach((key, value) {
      final tempTrabajador = Trabajador.fromMap(value);
      tempTrabajador.id = key;
      this.trabajadores.add(tempTrabajador);
    });
    isLoading = false;
    notifyListeners();
    return this.trabajadores;
  }

  Future saveOrCreateTrabajador(Trabajador trabajador) async {
    isSaving = true;
    notifyListeners();

    if (trabajador.id == null) {
      await createTrabajador(trabajador);
    } else {
      await updateTrabajador(trabajador);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateTrabajador(Trabajador trabajador) async {
    final url = Uri.https(_baseUrl, 'Trabajadores/${trabajador.id}.json');
    final res = await http.put(url, body: trabajador.toJson());
    final decodedData = res.body;
    print(decodedData);
    final index =
        this.trabajadores.indexWhere((element) => element.id == trabajador.id);
    this.trabajadores[index] = trabajador;
    return trabajador.id!;
  }

  Future<String> createTrabajador(Trabajador trabajador) async {
    final url = Uri.https(_baseUrl, 'trabajadores.json');
    final res = await http.post(url, body: trabajador.toJson());
    final decodedData = json.decode(res.body);
    trabajador.id = decodedData["name"];
    this.trabajadores.add(trabajador);
    return '';
  }
}
