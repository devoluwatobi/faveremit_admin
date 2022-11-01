// To parse this JSON data, do
//
//     final giftCardModel = giftCardModelFromJson(jsonString);

import 'dart:convert';

List<GiftCardModel> giftCardModelFromJson(String str) =>
    List<GiftCardModel>.from(
        json.decode(str).map((x) => GiftCardModel.fromJson(x)));

String giftCardModelToJson(List<GiftCardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiftCardModel {
  GiftCardModel({
    required this.id,
    required this.title,
    this.image,
    this.brandLogo,
    required this.status,
  });

  int id;
  int status;
  String title;
  String? image;
  String? brandLogo;

  factory GiftCardModel.fromJson(Map<String, dynamic> json) => GiftCardModel(
        id: int.parse(json["id"].toString()),
        status: int.parse(json["status"].toString()),
        title: json["title"],
        image: json["image"],
        brandLogo: json["brand_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "brand_logo": brandLogo,
      };
}
