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
    required this.giftCards,
    required this.transaction,
  });

  BtcRate btcRate;
  List<GiftCard> giftCards;
  List<DXTransaction> transaction;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        btcRate: BtcRate.fromJson(json["btc_rate"]),
        giftCards: List<GiftCard>.from(
            json["gift_cards"].map((x) => GiftCard.fromJson(x))),
        transaction: List<DXTransaction>.from(
            json["transaction"].map((x) => DXTransaction.fromJson(x))),
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
