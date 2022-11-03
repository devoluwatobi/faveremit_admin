// To parse this JSON data, do
//
//     final cryptoWalletAddress = cryptoWalletAddressFromJson(jsonString);

import 'dart:convert';

List<CryptoWalletAddress> cryptoWalletAddressFromJson(String str) =>
    List<CryptoWalletAddress>.from(
        json.decode(str).map((x) => CryptoWalletAddress.fromJson(x)));

String cryptoWalletAddressToJson(List<CryptoWalletAddress> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CryptoWalletAddress {
  CryptoWalletAddress({
    required this.id,
    required this.address,
    required this.cryptoId,
    required this.cryptoWalletTypeId,
    required this.serviceId,
    required this.updatedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.crypto,
  });

  int id;
  String address;
  int cryptoId;
  int cryptoWalletTypeId;
  int serviceId;
  int updatedBy;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  Crypto crypto;

  factory CryptoWalletAddress.fromJson(Map<String, dynamic> json) =>
      CryptoWalletAddress(
        id: json["id"],
        address: json["address"].toString(),
        cryptoId: int.parse(json["crypto_id"].toString()),
        cryptoWalletTypeId: int.parse(json["crypto_wallet_type_id"].toString()),
        serviceId: int.parse(json["service_id"].toString()),
        updatedBy: int.parse(json["updated_by"].toString()),
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        crypto: Crypto.fromJson(json["crypto"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "crypto_id": cryptoId,
        "crypto_wallet_type_id": cryptoWalletTypeId,
        "service_id": serviceId,
        "updated_by": updatedBy,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "crypto": crypto.toJson(),
      };
}

class Crypto {
  Crypto({
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

  factory Crypto.fromJson(Map<String, dynamic> json) => Crypto(
        id: json["id"],
        name: json["name"].toString(),
        shortCode: json["short_code"].toString(),
        icon: json["icon"].toString(),
        transactionIcon: json["transaction_icon"].toString(),
        serviceId: int.parse(json["service_id"].toString()),
        status: int.parse(json["status"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        description: json["description"].toString(),
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
