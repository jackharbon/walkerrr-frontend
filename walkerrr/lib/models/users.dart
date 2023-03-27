// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  Users({
    required this.id,
    required this.email,
    required this.displayName,
    required this.uid,
    required this.coins,
    required this.trophies,
    required this.quests,
    required this.equippedArmour,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String email;
  String displayName;
  String uid;
  int coins;
  List<dynamic> trophies;
  List<dynamic> quests;
  String equippedArmour;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["_id"],
        email: json["email"],
        displayName: json["displayName"],
        uid: json["uid"],
        coins: json["coins"],
        trophies: List<dynamic>.from(json["trophies"].map((x) => x)),
        quests: List<dynamic>.from(json["quests"].map((x) => x)),
        equippedArmour: json["equippedArmour"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "displayName": displayName,
        "uid": uid,
        "coins": coins,
        "trophies": List<dynamic>.from(trophies.map((x) => x)),
        "quests": List<dynamic>.from(quests.map((x) => x)),
        "equippedArmour": equippedArmour,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
