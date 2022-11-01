// To parse this JSON data, do
//
//     final btcTradeData = btcTradeDataFromJson(jsonString);

import 'dart:convert';

BtcTradeData btcTradeDataFromJson(String str) =>
    BtcTradeData.fromJson(json.decode(str));

String btcTradeDataToJson(BtcTradeData data) => json.encode(data.toJson());

class BtcTradeData {
  BtcTradeData({
    required this.walletTypes,
    required this.usdRate,
    required this.usdValue,
    required this.serviceId,
  });

  List<WalletType> walletTypes;
  int usdRate;
  double usdValue;
  int serviceId;

  factory BtcTradeData.fromJson(Map<String, dynamic> json) => BtcTradeData(
        walletTypes: List<WalletType>.from(
            json["wallet_types"].map((x) => WalletType.fromJson(x))),
        usdRate: int.parse(json["usd_rate"].toString()),
        usdValue: double.parse(json["usd_value"].toString()),
        serviceId: int.parse(json["service_id"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "wallet_types": List<dynamic>.from(walletTypes.map((x) => x.toJson())),
        "usd_rate": usdRate,
        "usd_value": usdValue,
        "service_id": serviceId,
      };
}

class WalletType {
  WalletType({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory WalletType.fromJson(Map<String, dynamic> json) => WalletType(
        id: int.parse(json["id"].toString()),
        name: json["name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
