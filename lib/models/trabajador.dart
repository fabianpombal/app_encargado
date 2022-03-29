// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class Trabajador {
  Trabajador(
      {required this.color,
      required this.name,
      required this.pasillo,
      this.id});

  String color;
  String name;
  int pasillo;
  String? id;

  factory Trabajador.fromJson(String str) =>
      Trabajador.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Trabajador.fromMap(Map<String, dynamic> json) => Trabajador(
        color: json["color"],
        name: json["name"],
        pasillo: json["pasillo"],
      );

  Map<String, dynamic> toMap() => {
        "color": color,
        "name": name,
        "pasillo": pasillo,
      };
}
