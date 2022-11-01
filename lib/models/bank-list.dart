// To parse this JSON data, do
//
//     final bankListModel = bankListModelFromJson(jsonString);

import 'dart:convert';

BankListModel bankListModelFromJson(String str) =>
    BankListModel.fromJson(json.decode(str));

String bankListModelToJson(BankListModel data) => json.encode(data.toJson());

class BankListModel {
  BankListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<BankModel> data;

  factory BankListModel.fromJson(Map<String, dynamic> json) => BankListModel(
        status: json["status"],
        message: json["message"],
        data: List<BankModel>.from(
            json["data"].map((x) => BankModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BankModel {
  BankModel({
    required this.id,
    required this.code,
    required this.name,
  });

  int id;
  String code;
  String name;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
      };
}
