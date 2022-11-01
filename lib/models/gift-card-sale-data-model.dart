// // To parse this JSON data, do
// //
// //     final giftCardSaleData = giftCardSaleDataFromJson(jsonString);
//
// import 'dart:convert';
//
// List<GiftCardCountry> giftCardSaleDataFromJson(String str) =>
//     List<GiftCardCountry>.from(
//         json.decode(str).map((x) => GiftCardCountry.fromJson(x)));
//
// String giftCardSaleDataToJson(List<GiftCardCountry> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class GiftCardCountry {
//   GiftCardCountry({
//     required this.id,
//     required this.giftCardId,
//     required this.countryId,
//     required this.range,
//   });
//
//   int id;
//   String giftCardId;
//   String countryId;
//   List<Range> range;
//
//   factory GiftCardCountry.fromJson(Map<String, dynamic> json) =>
//       GiftCardCountry(
//         id: json["id"],
//         giftCardId: json["gift_card_id"],
//         countryId: json["country_id"],
//         range: List<Range>.from(json["range"].map((x) => Range.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "gift_card_id": giftCardId,
//         "country_id": countryId,
//         "range": List<dynamic>.from(range.map((x) => x.toJson())),
//       };
// }
//
// class Range {
//   Range({
//     required this.id,
//     required this.giftCardId,
//     required this.giftCardCountryId,
//     required this.max,
//     required this.min,
//     required this.rate,
//   });
//
//   int id;
//   String giftCardId;
//   String giftCardCountryId;
//   String max;
//   String min;
//   String rate;
//
//   factory Range.fromJson(Map<String, dynamic> json) => Range(
//         id: json["id"],
//         giftCardId: json["gift_card_id"],
//         giftCardCountryId: json["gift_card_country_id"],
//         max: json["max"],
//         min: json["min"],
//         rate: json["rate"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "gift_card_id": giftCardId,
//         "gift_card_country_id": giftCardCountryId,
//         "max": max,
//         "min": min,
//         "rate": rate,
//       };
// }
