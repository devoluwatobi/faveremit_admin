// To parse this JSON data, do
//
//     final giftCardInfo = giftCardInfoFromJson(jsonString);

import 'dart:convert';

GiftCardInfo giftCardInfoFromJson(String str) =>
    GiftCardInfo.fromJson(json.decode(str));

String giftCardInfoToJson(GiftCardInfo data) => json.encode(data.toJson());

class GiftCardInfo {
  GiftCardInfo({
    required this.id,
    required this.title,
    required this.image,
    required this.brandLogo,
    required this.status,
    required this.createdAt,
    required this.countries,
  });

  int id;
  String title;
  String image;
  String brandLogo;
  int status;
  String createdAt;
  List<GiftCountry> countries;

  factory GiftCardInfo.fromJson(Map<String, dynamic> json) => GiftCardInfo(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        brandLogo: json["brand_logo"],
        status: int.parse(json["status"].toString()),
        createdAt: json["created_at"],
        countries: List<GiftCountry>.from(
            json["countries"].map((x) => GiftCountry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "brand_logo": brandLogo,
        "status": status,
        "created_at": createdAt,
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

class GiftCountry {
  GiftCountry({
    required this.id,
    required this.status,
    required this.name,
    required this.iso,
    required this.image,
    required this.ranges,
  });

  int id;
  int status;
  String name;
  String image;
  String iso;
  int ranges;

  factory GiftCountry.fromJson(Map<String, dynamic> json) => GiftCountry(
        id: json["id"],
        status: int.parse(json["status"].toString()),
        name: json["name"],
        iso: json["iso"],
        image: json["image"],
        ranges: json["ranges"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "ranges": ranges,
      };
}
