import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrabajadorService extends ChangeNotifier {
  final String _baseUrl =
      'lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Trabajador> trabajadores = [];
  late Trabajador trabajadorSeleccionado;

  final Color color0 = const Color.fromRGBO(0, 0, 0, 1);
  final Color color1 = const Color.fromRGBO(255, 0, 0, 1);
  final Color color2 = const Color.fromRGBO(0, 255, 0, 1);
  final Color color3 = const Color.fromRGBO(0, 0, 255, 1);
  final Color color4 = const Color.fromRGBO(255, 255, 255, 1);
  final Color color5 = const Color.fromRGBO(255, 255, 0, 1);
  final Color color6 = const Color.fromRGBO(255, 0, 255, 1);
  final Color color7 = const Color.fromRGBO(0, 255, 255, 1);
  final Color color8 = const Color.fromRGBO(210, 70, 0, 1);

  bool isLoading = true;
  bool isSaving = true;

  TrabajadorService() {
    loadTrabajadores();
  }

  Future<List<Trabajador>> loadTrabajadores() async {
    notifyListeners();
    final url = Uri.https(_baseUrl, '/trabajadores.json');
    final res = await http.get(url);

    final Map<String, dynamic> trabajadoresMap = json.decode(res.body);
    trabajadoresMap.forEach((key, value) {
      final tempTrabajador = Trabajador.fromMap(value);
      tempTrabajador.id = key;
      // print(tempTrabajador.id);
      trabajadores.add(tempTrabajador);
    });
    isLoading = false;
    notifyListeners();
    return trabajadores;
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
    final url = Uri.https(_baseUrl, 'trabajadores/${trabajador.id}.json');
    final res = await http.put(url, body: trabajador.toJson());
    final decodedData = res.body;
    //print(decodedData);
    final index =
        trabajadores.indexWhere((element) => element.id == trabajador.id);
    trabajadores[index] = trabajador;
    return trabajador.id!;
  }

  Future<String> createTrabajador(Trabajador trabajador) async {
    final url = Uri.https(_baseUrl, 'trabajadores.json');
    final res = await http.post(url, body: trabajador.toJson());
    final decodedData = json.decode(res.body);
    trabajador.id = decodedData["name"];
    trabajadores.add(trabajador);
    return '';
  }

  void updateState() {
    notifyListeners();
  }
}
