import 'dart:convert';

class Trabajador {
  Trabajador(
      {required this.color,
      required this.name,
      required this.trabajando,
      required this.rfidTag,
      required this.pedidos,
      this.picture,
      this.id});

  String color;
  String name;
  int pedidos;
  bool trabajando;
  String rfidTag;
  String? picture;
  String? id;

  factory Trabajador.fromJson(String str) =>
      Trabajador.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Trabajador.fromMap(Map<String, dynamic> json) => Trabajador(
      color: json["color"],
      name: json["name"],
      picture: json["picture"],
      trabajando: json["trabajando"],
      rfidTag: json["rfidTag"],
      pedidos: json["pedidos"]);

  Map<String, dynamic> toMap() => {
        "color": color,
        "name": name,
        "trabajando": trabajando,
        "picture": picture,
        "rfidTag": rfidTag,
        "pedidos": pedidos
      };

  Trabajador copy() => Trabajador(
      color: color,
      name: name,
      trabajando: trabajando,
      id: id,
      pedidos: pedidos,
      rfidTag: rfidTag);
}
