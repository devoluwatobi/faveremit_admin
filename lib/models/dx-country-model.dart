// To parse this JSON data, do
//
//     final dxCountryModel = dxCountryModelFromJson(jsonString);

import 'dart:convert';

List<DxCountryModel> dxCountryModelFromJson(String str) =>
    List<DxCountryModel>.from(
        json.decode(str).map((x) => DxCountryModel.fromJson(x)));

String dxCountryModelToJson(List<DxCountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DxCountryModel {
  DxCountryModel({
    required this.id,
    required this.name,
    required this.iso,
    required this.image,
  });

  int id;
  String name;
  String iso;
  String image;

  factory DxCountryModel.fromJson(Map<String, dynamic> json) => DxCountryModel(
        id: json["id"],
        name: json["name"],
        iso: json["iso"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso": iso,
        "image": image,
      };
}
