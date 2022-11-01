// To parse this JSON data, do
//
//     final withdrawalTrxModel = withdrawalTrxModelFromJson(jsonString);

import 'dart:convert';

WithdrawalTrxModel withdrawalTrxModelFromJson(String str) =>
    WithdrawalTrxModel.fromJson(json.decode(str));

String withdrawalTrxModelToJson(WithdrawalTrxModel data) =>
    json.encode(data.toJson());

class WithdrawalTrxModel {
  WithdrawalTrxModel({
    required this.message,
    required this.transaction,
  });

  String message;
  WithdrawalTransaction transaction;

  factory WithdrawalTrxModel.fromJson(Map<String, dynamic> json) =>
      WithdrawalTrxModel(
        message: json["message"],
        transaction: WithdrawalTransaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "transaction": transaction.toJson(),
      };
}

class WithdrawalTransaction {
  WithdrawalTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionRef,
    required this.status,
    required this.approvedBy,
    required this.rejectedBy,
    required this.rejectedReason,
    required this.bank,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String amount;
  String transactionRef;
  String status;
  dynamic approvedBy;
  dynamic rejectedBy;
  dynamic rejectedReason;
  WithdrawalBank bank;
  DateTime createdAt;
  DateTime updatedAt;

  factory WithdrawalTransaction.fromJson(Map<String, dynamic> json) =>
      WithdrawalTransaction(
        id: json["id"],
        userId: int.parse(json["user_id"].toString()),
        amount: json["amount"].toString(),
        transactionRef: json["transaction_ref"].toString(),
        status: json["status"].toString(),
        approvedBy: json["approved_by"],
        rejectedBy: json["rejected_by"],
        rejectedReason: json["rejected_reason"],
        bank: WithdrawalBank.fromJson(json["bank"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount": amount,
        "transaction_ref": transactionRef,
        "status": status,
        "approved_by": approvedBy,
        "rejected_by": rejectedBy,
        "rejected_reason": rejectedReason,
        "bank": bank.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class WithdrawalBank {
  WithdrawalBank({
    required this.bank,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  String bank;
  String bankName;
  String accountNumber;
  String accountName;

  factory WithdrawalBank.fromJson(Map<String, dynamic> json) => WithdrawalBank(
        bank: json["bank"].toString(),
        bankName: json["bank_name"].toString(),
        accountNumber: json["account_number"].toString(),
        accountName: json["account_name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "bank": bank,
        "bank_name": bankName,
        "account_number": accountNumber,
        "account_name": accountName,
      };
}
