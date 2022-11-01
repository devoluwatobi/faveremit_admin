// To parse this JSON data, do
//
//     final dxUserModel = dxUserModelFromJson(jsonString);

import 'dart:convert';

List<DxUserModel> dxUserModelFromJson(String str) => List<DxUserModel>.from(
    json.decode(str).map((x) => DxUserModel.fromJson(x)));

String dxUserModelToJson(List<DxUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DxUserModel {
  DxUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.photo,
  });

  int id;
  String name;
  String email;
  String phone;
  int role;
  DateTime createdAt;
  String photo;

  factory DxUserModel.fromJson(Map<String, dynamic> json) => DxUserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"].toString(),
        role: int.parse(json["role"].toString()),
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
