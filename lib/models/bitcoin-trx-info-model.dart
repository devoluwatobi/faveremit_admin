// To parse this JSON data, do
//
//     final bitcoinTrxModel = bitcoinTrxModelFromJson(jsonString);

import 'dart:convert';

BitcoinTrxModel bitcoinTrxModelFromJson(String str) =>
    BitcoinTrxModel.fromJson(json.decode(str));

String bitcoinTrxModelToJson(BitcoinTrxModel data) =>
    json.encode(data.toJson());

class BitcoinTrxModel {
  BitcoinTrxModel({
    required this.message,
    required this.transaction,
  });

  String message;
  CryptoTransaction transaction;

  factory BitcoinTrxModel.fromJson(Map<String, dynamic> json) =>
      BitcoinTrxModel(
        message: json["message"],
        transaction: CryptoTransaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "transaction": transaction.toJson(),
      };
}

class CryptoTransaction {
  CryptoTransaction({
    required this.id,
    required this.userId,
    required this.icon,
    required this.serviceId,
    required this.walletType,
    required this.cryptoName,
    required this.walletAddress,
    required this.usdAmount,
    required this.cryptoAmount,
    required this.cryptoShortCode,
    required this.usdRate,
    required this.ngnAmount,
    required this.transactionRef,
    required this.status,
    required this.proof,
    required this.rejectedReason,
    required this.approvedBy,
    required this.rejectedBy,
    required this.updatedAt,
    required this.createdAt,
    required this.iso,
  });

  int id;
  int userId;
  String icon;
  int serviceId;
  String walletType;
  String cryptoName;
  String walletAddress;
  String usdAmount;
  String cryptoAmount;
  String cryptoShortCode;
  String usdRate;
  String ngnAmount;
  String transactionRef;
  String status;
  String proof;
  String rejectedReason;
  dynamic approvedBy;
  dynamic rejectedBy;
  DateTime updatedAt;
  DateTime createdAt;
  String iso;

  factory CryptoTransaction.fromJson(Map<String, dynamic> json) =>
      CryptoTransaction(
        id: json["id"],
        userId: int.parse(json["user_id"].toString()),
        icon: json["icon"],
        cryptoName: json["crypto_name"].toString(),
        serviceId: int.parse(json["service_id"].toString()),
        walletType: json["wallet_type"].toString(),
        walletAddress: json["wallet_address"].toString(),
        usdAmount: json["usd_amount".toString()],
        cryptoAmount: json["crypto_amount"].toString(),
        cryptoShortCode: json["crypto_short_code"].toString(),
        usdRate: json["usd_rate"].toString(),
        ngnAmount: json["ngn_amount"].toString(),
        transactionRef: json["transaction_ref"].toString(),
        status: json["status"].toString(),
        proof: json["proof"].toString(),
        rejectedReason: json["rejected_reason"].toString(),
        approvedBy: json["approved_by"],
        rejectedBy: json["rejected_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        iso: json["iso"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "icon": icon,
        "service_id": serviceId,
        "wallet_type": walletType,
        "usd_amount": usdAmount,
        "btc_amount": cryptoAmount,
        "usd_rate": usdRate,
        "ngn_amount": ngnAmount,
        "transaction_ref": transactionRef,
        "status": status,
        "proof": proof,
        "rejected_reason": rejectedReason,
        "approved_by": approvedBy,
        "rejected_by": rejectedBy,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "iso": iso,
      };
}
