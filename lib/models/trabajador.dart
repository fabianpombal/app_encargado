import 'dart:convert';

class Trabajador {
  Trabajador(
      {required this.color,
      required this.name,
      required this.pasillo,
      required this.rfidTag,
      this.id});

  String color;
  String name;
  int pasillo;
  String rfidTag;
  String? id;

  factory Trabajador.fromJson(String str) =>
      Trabajador.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Trabajador.fromMap(Map<String, dynamic> json) => Trabajador(
        color: json["color"],
        name: json["name"],
        pasillo: json["pasillo"],
        rfidTag: json["rfidTag"],
      );

  Map<String, dynamic> toMap() =>
      {"color": color, "name": name, "pasillo": pasillo, "rfidTag": rfidTag};

  Trabajador copy() => Trabajador(
      color: this.color,
      name: this.name,
      pasillo: this.pasillo,
      id: this.id,
      rfidTag: this.rfidTag);
}
