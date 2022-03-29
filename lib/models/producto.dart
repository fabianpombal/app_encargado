// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class Producto {
  Producto(
      {required this.estante,
      required this.name,
      required this.stock,
      required this.valda,
      this.id});

  int estante;
  String name;
  int stock;
  int valda;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        estante: json["estante"],
        name: json["name"],
        stock: json["stock"],
        valda: json["valda"],
      );

  Map<String, dynamic> toMap() => {
        "estante": estante,
        "name": name,
        "stock": stock,
        "valda": valda,
      };
}
