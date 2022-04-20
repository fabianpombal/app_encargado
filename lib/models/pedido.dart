// To parse this JSON data, do
//
//     final pedido = pedidoFromMap(jsonString);

import 'dart:convert';

class Pedido {
  Pedido(
      {required this.productos,
      required this.trabajadorId,
      required this.completed,
      this.id});

  String productos;
  String trabajadorId;
  bool completed;
  String? id;

  factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
      productos: json["productos"],
      trabajadorId: json["trabajadorId"],
      completed: json["completed"]);

  Map<String, dynamic> toMap() => {
        "productos": productos,
        "trabajadorId": trabajadorId,
        "completed": completed
      };

  Pedido copy() => Pedido(
        productos: this.productos,
        trabajadorId: this.trabajadorId,
        completed: this.completed,
        id: this.id,
      );
}
