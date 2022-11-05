// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

import 'dart:convert';

import 'package:faveremit_admin/models/transactions-object.dart';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  HomeData({
    required this.btcRate,
    required this.cryptoRates,
    required this.giftCards,
    required this.transaction,
  });

  BtcRate btcRate;
  List<GiftCard> giftCards;
  List<FavTransaction> transaction;
  List<CryptoRate> cryptoRates;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        btcRate: BtcRate.fromJson(json["btc_rate"]),
        cryptoRates: List<CryptoRate>.from(
            json["crypto_rates"].map((x) => CryptoRate.fromJson(x))),
        giftCards: List<GiftCard>.from(
            json["gift_cards"].map((x) => GiftCard.fromJson(x))),
        transaction: List<FavTransaction>.from(
            json["transaction"].map((x) => FavTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "btc_rate": btcRate.toJson(),
        "gift_cards": List<dynamic>.from(giftCards.map((x) => x.toJson())),
        "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
      };
}

class BtcRate {
  BtcRate({
    required this.name,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
  });

  String name;
  String value;
  DateTime createdAt;
  DateTime updatedAt;
  int updatedBy;

  factory BtcRate.fromJson(Map<String, dynamic> json) => BtcRate(
        name: json["name"],
        value: json["value"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: int.parse(json["updated_by"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "name": name.toString(),
        "value": value.toString(),
      };
}

class GiftCard {
  GiftCard({
    required this.id,
    required this.title,
    required this.image,
    required this.brandLogo,
    required this.serviceId,
  });

  int id;
  String title;
  String image;
  String brandLogo;
  int serviceId;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        id: json["id"],
        title: json["title"].toString(),
        image: json["image"].toString(),
        brandLogo: json["brand_logo"].toString(),
        serviceId: int.parse(json["service_id"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "brand_logo": brandLogo,
        "service_id": serviceId,
      };
}

class CryptoRate {
  CryptoRate({
    required this.id,
    required this.value,
    required this.cryptoId,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.crypto,
  });

  int id;
  String value;
  int cryptoId;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  Crypto crypto;

  factory CryptoRate.fromJson(Map<String, dynamic> json) => CryptoRate(
        id: json["id"],
        value: json["value"],
        cryptoId: json["crypto_id"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        crypto: Crypto.fromJson(json["crypto"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "crypto_id": cryptoId,
        "updated_by": updatedBy,
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
  String? icon;
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
        icon: json["icon"] == null ? json["icon"] : json["icon"].toString(),
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
