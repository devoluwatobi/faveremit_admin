// To parse this JSON data, do
//
//     final btcWalletModel = btcWalletModelFromJson(jsonString);

import 'dart:convert';

List<BtcWalletModel> btcWalletModelFromJson(String str) =>
    List<BtcWalletModel>.from(
        json.decode(str).map((x) => BtcWalletModel.fromJson(x)));

String btcWalletModelToJson(List<BtcWalletModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BtcWalletModel {
  BtcWalletModel({
    required this.id,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
  });

  int id;
  String address;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int updatedBy;

  factory BtcWalletModel.fromJson(Map<String, dynamic> json) => BtcWalletModel(
        id: json["id"],
        address: json["address"],
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: int.parse(json["updated_by"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "updated_by": updatedBy,
      };
}
