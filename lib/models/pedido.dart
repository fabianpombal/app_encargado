import 'dart:convert';

class Pedido {
  Pedido(
      {required this.estado,
      required this.idProducto,
      required this.idTrabajador,
      required this.numProductos,
      this.id});

  String estado;
  String idProducto;
  String idTrabajador;
  int numProductos;
  String? id;

  factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
        estado: json["estado"],
        idProducto: json["idProducto"],
        idTrabajador: json["idTrabajador"],
        numProductos: json["numProductos"],
      );

  Map<String, dynamic> toMap() => {
        "estado": estado,
        "idProducto": idProducto,
        "idTrabajador": idTrabajador,
        "numProductos": numProductos,
      };

  Pedido copy() => Pedido(
      estado: this.estado,
      idProducto: this.idProducto,
      idTrabajador: this.idTrabajador,
      numProductos: this.numProductos,
      id: this.id);
}
