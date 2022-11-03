// To parse this JSON data, do
//
//     final cryptoModel = cryptoModelFromJson(jsonString);

import 'dart:convert';

List<CryptoModel> cryptoModelFromJson(String str) => List<CryptoModel>.from(
    json.decode(str).map((x) => CryptoModel.fromJson(x)));

String cryptoModelToJson(List<CryptoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CryptoModel {
  CryptoModel({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.icon,
    required this.transactionIcon,
    required this.serviceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  int id;
  String name;
  String shortCode;
  String icon;
  String transactionIcon;
  int serviceId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String description;

  factory CryptoModel.fromJson(Map<String, dynamic> json) => CryptoModel(
        id: json["id"],
        name: json["name"],
        shortCode: json["short_code"],
        icon: json["icon"],
        transactionIcon: json["transaction_icon"],
        serviceId: int.parse(json["service_id"].toString()),
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_code": shortCode,
        "icon": icon,
        "transaction_icon": transactionIcon,
        "service_id": serviceId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "description": description,
      };
}
