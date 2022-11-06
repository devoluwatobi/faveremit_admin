// To parse this JSON data, do
//
//     final dxUserModel = dxUserModelFromJson(jsonString);

import 'dart:convert';

List<FavUserModel> dxUserModelFromJson(String str) => List<FavUserModel>.from(
    json.decode(str).map((x) => FavUserModel.fromJson(x)));

String dxUserModelToJson(List<FavUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavUserModel {
  FavUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.balance,
    required this.referrer,
    required this.username,
    required this.createdAt,
    required this.photo,
  });

  int id;
  String name;
  String email;
  String phone;
  String balance;
  String? referrer;
  String username;
  int status;
  int role;
  DateTime createdAt;
  String photo;

  factory FavUserModel.fromJson(Map<String, dynamic> json) => FavUserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"].toString(),
        balance: json["balance"].toString(),
        referrer: json["referrer"] == null
            ? json["referrer"]
            : json["referrer"].toString(),
        username: json["username"].toString(),
        role: int.parse(json["role"].toString()),
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        photo: json["photo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "created_at": createdAt.toIso8601String(),
        "photo": photo,
      };
}
