import 'dart:convert';

class Trabajador {
  Trabajador(
      {required this.color,
      required this.name,
      required this.trabajando,
      required this.rfidTag,
      this.picture,
      this.id});

  String color;
  String name;
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
      );

  Map<String, dynamic> toMap() => {
        "color": color,
        "name": name,
        "trabajando": trabajando,
        "picture": picture,
        "rfidTag": rfidTag
      };

  Trabajador copy() => Trabajador(
      color: this.color,
      name: this.name,
      trabajando: this.trabajando,
      id: this.id,
      rfidTag: this.rfidTag);
}
