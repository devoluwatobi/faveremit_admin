// To parse this JSON data, do
//
//     final transactionsListModel = transactionsListModelFromJson(jsonString);

import 'dart:convert';

TransactionsListModel transactionsListModelFromJson(String str) =>
    TransactionsListModel.fromJson(json.decode(str));

String transactionsListModelToJson(TransactionsListModel data) =>
    json.encode(data.toJson());

class TransactionsListModel {
  TransactionsListModel({
    required this.giftCards,
    required this.bitcoins,
    required this.withdrawals,
    // required this.utility,
  });

  List<dynamic> giftCards;
  List<dynamic> bitcoins;
  List<dynamic> withdrawals;
  // List<dynamic> utility;

  factory TransactionsListModel.fromJson(Map<String, dynamic> json) =>
      TransactionsListModel(
        // giftCards: json["gift_cards"] == null ? null : List<dynamic>.from(json["gift_cards"].map((x) => x)),
        giftCards: List<DXTransaction>.from(
            json["gift_cards"].map((x) => DXTransaction.fromJson(x))),

        // bitcoins: json["bitcoins"] == null ? null : List<dynamic>.from(json["bitcoins"].map((x) => x)),
        bitcoins: List<DXTransaction>.from(
            json["bitcoins"].map((x) => DXTransaction.fromJson(x))),

        withdrawals: List<dynamic>.from(
            json["withdrawals"].map((x) => DXTransaction.fromJson(x))),
        // utility: List<DXTransaction>.from(
        //     json["utility"].map((x) => DXTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "gift_cards": giftCards == null ? null : List<dynamic>.from(giftCards.map((x) => x)),
        "gift_cards": List<dynamic>.from(giftCards.map((x) => x.toJson())),

        // "bitcoins": bitcoins == null ? null : List<dynamic>.from(bitcoins.map((x) => x)),
        "bitcoins": List<dynamic>.from(bitcoins.map((x) => x.toJson())),

        // "utility": utility == null ? null : List<dynamic>.from(utility.map((x) => x)),
        // "utility": List<dynamic>.from(utility.map((x) => x.toJson())),
      };
}

class DXTransaction {
  DXTransaction({
    required this.id,
    required this.userId,
    this.icon,
    required this.serviceId,
    required this.usdAmount,
    required this.usdRate,
    required this.ngnAmount,
    required this.transactionRef,
    required this.status,
    required this.type,
    required this.title,
    required this.iso,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.createdAt,
  });

  int id;
  int userId;
  String? icon;
  int? serviceId;
  String? usdAmount;
  String? title;
  String? type;
  String? iso;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? usdRate;
  String? ngnAmount;
  String transactionRef;
  DateTime createdAt;
  int status;

  factory DXTransaction.fromJson(Map<String, dynamic> json) => DXTransaction(
        id: int.parse(json["id"].toString()),
        userId: int.parse(json["user_id"].toString()),
        icon: json["icon"],
        title: json["title"],
        type: json["type"],
        iso: json["iso"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        serviceId: json["service_id"] == null
            ? json["service_id"]
            : int.parse(json["service_id"].toString()),
        usdAmount: json["usd_amount"].toString(),
        usdRate: json["usd_rate"].toString(),
        ngnAmount: json["ngn_amount"].toString(),
        transactionRef: json["transaction_ref"].toString(),
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "icon": icon,
        "service_id": serviceId,
        "usd_amount": usdAmount,
        "usd_rate": usdRate,
        "ngn_amount": ngnAmount,
        "transaction_ref": transactionRef,
        "status": status,
      };
}
