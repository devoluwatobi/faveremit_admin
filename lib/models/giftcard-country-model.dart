// To parse this JSON data, do
//
//     final giftCardCountry = giftCardCountryFromJson(jsonString);

import 'dart:convert';

GiftCardCountry giftCardCountryFromJson(String str) =>
    GiftCardCountry.fromJson(json.decode(str));

String giftCardCountryToJson(GiftCardCountry data) =>
    json.encode(data.toJson());

class GiftCardCountry {
  GiftCardCountry({
    required this.id,
    required this.cardTitle,
    required this.country,
    required this.image,
    required this.iso,
    required this.status,
    required this.ranges,
  });

  int id;
  String cardTitle;
  String country;
  String image;
  String iso;
  String status;
  List<GiftCardRange> ranges;

  factory GiftCardCountry.fromJson(Map<String, dynamic> json) =>
      GiftCardCountry(
        id: json["id"],
        cardTitle: json["card_title"].toString(),
        country: json["country"].toString(),
        image: json["image"].toString(),
        iso: json["iso"].toString(),
        status: json["status"].toString(),
        ranges: List<GiftCardRange>.from(
            json["ranges"].map((x) => GiftCardRange.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "card_title": cardTitle,
        "country": country,
        "image": image,
        "iso": iso,
        "status": status,
        "ranges": List<dynamic>.from(ranges.map((x) => x.toJson())),
      };
}

class GiftCardRange {
  GiftCardRange({
    required this.id,
    required this.giftCardId,
    required this.giftCardCountryId,
    required this.min,
    required this.max,
    required this.status,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.receiptCategories,
  });

  int id;
  int giftCardId;
  int giftCardCountryId;
  int min;
  int max;
  String status;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<ReceiptCategory> receiptCategories;

  factory GiftCardRange.fromJson(Map<String, dynamic> json) => GiftCardRange(
        id: json["id"],
        giftCardId: int.parse(json["gift_card_id"].toString()),
        giftCardCountryId: int.parse(json["gift_card_country_id"].toString()),
        min: int.parse(json["min"].toString()),
        max: int.parse(json["max"].toString()),
        status: json["status"].toString(),
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        receiptCategories: List<ReceiptCategory>.from(
            json["receipt_categories"].map((x) => ReceiptCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_card_id": giftCardId,
        "gift_card_country_id": giftCardCountryId,
        "min": min,
        "max": max,
        "status": status,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "receipt_categories":
            List<dynamic>.from(receiptCategories.map((x) => x.toJson())),
      };
}

class ReceiptCategory {
  ReceiptCategory({
    required this.id,
    required this.title,
    required this.amount,
    required this.giftCardId,
    required this.updatedBy,
    required this.status,
    required this.updatedAt,
    required this.giftCardCountryId,
  });

  int id;
  String title;
  String amount;
  int giftCardId;
  int status;
  int updatedBy;
  DateTime updatedAt;
  int giftCardCountryId;

  factory ReceiptCategory.fromJson(Map<String, dynamic> json) =>
      ReceiptCategory(
        id: json["id"],
        title: json["title"].toString(),
        amount: json["amount"].toString(),
        updatedBy: int.parse(json["updated_by"].toString()),
        status: int.parse(json["status"].toString()),
        updatedAt: DateTime.parse(json["updated_at"]),
        giftCardId: int.parse(json["gift_card_id"].toString()),
        giftCardCountryId: int.parse(json["gift_card_country_id"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "gift_card_id": giftCardId,
        "gift_card_country_id": giftCardCountryId,
      };
}
