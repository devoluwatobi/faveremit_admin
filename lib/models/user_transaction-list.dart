// To parse this JSON data, do
//
//     final favTransaction = favTransactionFromJson(jsonString);

import 'dart:convert';

List<UserFavTransaction> favTransactionFromJson(String str) =>
    List<UserFavTransaction>.from(
        json.decode(str).map((x) => UserFavTransaction.fromJson(x)));

String favTransactionToJson(List<UserFavTransaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserFavTransaction {
  UserFavTransaction({
    required this.id,
    required this.title,
    required this.type,
    required this.subTypeId,
    required this.icon,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String type;
  int subTypeId;
  String icon;
  String amount;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserFavTransaction.fromJson(Map<String, dynamic> json) =>
      UserFavTransaction(
        id: json["id"],
        title: json["title"].toString(),
        type: json["type"].toString(),
        subTypeId: int.parse(json["sub_type_id"].toString()),
        icon: json["icon"].toString(),
        amount: json["amount"].toString(),
        status: json["status"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "sub_type_id": subTypeId,
        "icon": icon,
        "amount": amount,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
