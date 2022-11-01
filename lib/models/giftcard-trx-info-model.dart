// To parse this JSON data, do
//
//     final giftCardTrxModel = giftCardTrxModelFromJson(jsonString);

import 'dart:convert';

GiftCardTrxModel giftCardTrxModelFromJson(String str) =>
    GiftCardTrxModel.fromJson(json.decode(str));

String giftCardTrxModelToJson(GiftCardTrxModel data) =>
    json.encode(data.toJson());

class GiftCardTrxModel {
  GiftCardTrxModel({
    required this.message,
    required this.transaction,
  });

  String message;
  GTransaction transaction;

  factory GiftCardTrxModel.fromJson(Map<String, dynamic> json) =>
      GiftCardTrxModel(
        message: json["message"],
        transaction: GTransaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "transaction": transaction.toJson(),
      };
}

class GTransaction {
  GTransaction({
    required this.id,
    required this.userId,
    required this.icon,
    required this.serviceId,
    required this.cardValue,
    required this.usdRate,
    required this.ngnAmount,
    required this.transactionRef,
    required this.status,
    required this.giftcardType,
    required this.proof,
    required this.secondProof,
    required this.thirdProof,
    required this.receiptAvailability,
    required this.currency,
    required this.note,
    required this.category,
    required this.rejectedReason,
    required this.approvedBy,
    required this.rejectedBy,
    required this.range,
    required this.country,
    required this.iso,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String icon;
  int serviceId;
  String cardValue;
  String usdRate;
  String ngnAmount;
  String transactionRef;
  String status;
  String giftcardType;
  String proof;
  String? secondProof;
  String? thirdProof;
  String currency;
  String category;
  String receiptAvailability;
  String? note;
  dynamic rejectedReason;
  dynamic approvedBy;
  dynamic rejectedBy;
  GRange range;
  String country;
  String iso;
  DateTime createdAt;
  DateTime updatedAt;

  factory GTransaction.fromJson(Map<String, dynamic> json) => GTransaction(
        id: json["id"],
        userId: int.parse(json["user_id"].toString()),
        icon: json["icon"],
        serviceId: int.parse(json["service_id"].toString()),
        cardValue: json["card_value"].toString(),
        usdRate: json["usd_rate"].toString(),
        ngnAmount: json["ngn_amount"].toString(),
        transactionRef: json["transaction_ref"].toString(),
        status: json["status"].toString(),
        giftcardType: json["giftcard_type"].toString(),
        proof: json["proof"],
        secondProof: json["second_proof"] == null
            ? json["second_proof"]
            : json["second_proof"].toString(),
        thirdProof: json["third_proof"] == null
            ? json["third_proof"]
            : json["third_proof"].toString(),
        receiptAvailability: json["receipt_availability"].toString(),
        note: json["note"],
        category: json["category"].toString(),
        rejectedReason: json["rejected_reason"],
        approvedBy: json["approved_by"],
        rejectedBy: json["rejected_by"],
        range: GRange.fromJson(json["range"]),
        country: json["country"],
        iso: json["iso"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        currency: json["currency"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "icon": icon,
        "service_id": serviceId,
        "card_value": cardValue,
        "usd_rate": usdRate,
        "ngn_amount": ngnAmount,
        "transaction_ref": transactionRef,
        "status": status,
        "giftcard_type": giftcardType,
        "proof": proof,
        "receipt_availability": receiptAvailability,
        "note": note,
        "rejected_reason": rejectedReason,
        "approved_by": approvedBy,
        "rejected_by": rejectedBy,
        "range": range.toJson(),
        "country": country,
        "iso": iso,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class GRange {
  GRange({
    required this.max,
    required this.min,
    required this.rate,
  });

  int max;
  int min;
  String rate;

  factory GRange.fromJson(Map<String, dynamic> json) => GRange(
        max: int.parse(json["max"].toString()),
        min: int.parse(json["min"].toString()),
        rate: json["rate"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "max": max,
        "min": min,
        "rate": rate,
      };
}
