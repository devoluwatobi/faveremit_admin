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
    required this.status,
    required this.country,
    required this.cardTitle,
    required this.image,
    required this.iso,
    required this.ranges,
  });

  int id;
  int status;
  String country;
  String cardTitle;
  String image;
  String iso;
  List<GiftCardRange> ranges;

  factory GiftCardCountry.fromJson(Map<String, dynamic> json) =>
      GiftCardCountry(
        id: json["id"],
        status: int.parse(json["status"].toString()),
        country: json["country"],
        cardTitle: json["card_title"],
        image: json["image"],
        iso: json["iso"],
        ranges: List<GiftCardRange>.from(
            json["ranges"].map((x) => GiftCardRange.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "image": image,
        "iso": iso,
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
    required this.ecodeRate,
    required this.physicalRate,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
  });

  int id;
  int giftCardId;
  int giftCardCountryId;
  int min;
  int max;
  String status;
  int ecodeRate;
  int physicalRate;
  int? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory GiftCardRange.fromJson(Map<String, dynamic> json) => GiftCardRange(
        id: json["id"],
        giftCardId: int.parse(json["gift_card_id"].toString()),
        giftCardCountryId: int.parse(json["gift_card_country_id"].toString()),
        min: int.parse(json["min"].toString()),
        max: int.parse(json["max"].toString()),
        status: json["status"].toString(),
        ecodeRate: int.parse(json["ecode_rate"].toString()),
        physicalRate: int.parse(json["physical_rate"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: int.parse(json["updated_by"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_card_id": giftCardId,
        "gift_card_country_id": giftCardCountryId,
        "min": min,
        "max": max,
        "ecode_rate": ecodeRate,
        "physical_rate": physicalRate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
