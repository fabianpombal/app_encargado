import 'dart:convert';

class Producto {
  Producto(
      {required this.columna,
      required this.name,
      required this.stock,
      required this.fila,
      required this.rfidTag,
      this.id});

  int columna;
  String name;
  int stock;
  int fila;
  String rfidTag;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
      columna: json["columna"],
      name: json["name"],
      stock: json["stock"],
      fila: json["fila"],
      rfidTag: json["rfidTag"]);

  Map<String, dynamic> toMap() => {
        "columna": columna,
        "name": name,
        "stock": stock,
        "fila": fila,
        "rfidTag": rfidTag,
      };
}
