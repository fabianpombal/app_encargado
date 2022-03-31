import 'dart:convert';

class Producto {
  Producto(
      {required this.estante,
      required this.name,
      required this.stock,
      required this.valda,
      required this.rfidTag,
      this.id});

  int estante;
  String name;
  int stock;
  int valda;
  String rfidTag;
  String? id;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        estante: json["estante"],
        name: json["name"],
        stock: json["stock"],
        valda: json["valda"],
        rfidTag: json["rfidTag"]
      );

  Map<String, dynamic> toMap() => {
        "estante": estante,
        "name": name,
        "stock": stock,
        "valda": valda,
        "rfidTag": rfidTag,
      };
}
