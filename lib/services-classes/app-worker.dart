import 'dart:convert';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:faveremit_admin/models/crypto_wallet_address.dart';
import 'package:faveremit_admin/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/bank-list.dart';
import '../models/bitcoin-trx-info-model.dart';
import '../models/btc-trade-data.dart';
import '../models/cryptos.dart';
import '../models/dx-country-model.dart';
import '../models/dx-user-model.dart';
import '../models/gift-card-mode.dart';
import '../models/giftcard-country-model.dart';
import '../models/giftcard-trx-info-model.dart';
import '../models/home-data-info.dart';
import '../models/single-giftcard-model.dart';
import '../models/transactions-object.dart';
import '../models/user_transaction-list.dart';
import '../models/withdrawal-trx-info-model.dart';

late String userFullName;
late String userPhone;
String _verificationToken = "";

class AppWorker {
  AppWorker._();

  factory AppWorker() => _instance;

  static final AppWorker _instance = AppWorker._();

  var localAuth = LocalAuthentication();

  bool _initialized = false;
  final String _apiBaseUrl = "http://127.0.0.1:8000/api/admin";
  // final String _apiBaseUrl = "https://api.faveremit.com/api/ss1admin";
  final String baseUrl = "http://127.0.0.1:8000";
  // final String baseUrl = "https://api.faveremit.com/";
  late UserModel? _faveremitUser;
  late String? userMapString;
  late bool userAvailable;

  late SharedPreferences _prefs;
  late bool _useBiometrics;

  Future<void> init({required BuildContext context}) async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();

      if (_prefs.containsKey("userMap")) {
        userAvailable = true;
        userMapString = _prefs.getString("userMap");
        // _userMap = jsonDecode(_userMapString!);
        _faveremitUser = userModelFromJson(userMapString!);
        Provider.of<UserData>(context, listen: false)
            .updateUserDetails(_faveremitUser!);
      }

      _initialized = true;
    }
  }

  Future<SignInError> signUp(
      {required String fullName,
      required String email,
      required String phone,
      required String password,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": fullName,
          "email": email,
          "phone": phone,
          "password": password
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return SignInError(
        emailXPhone: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }
      userFullName = fullName;
      userPhone = phone.toString();
      await _prefs.setString("fullName", fullName);
      await _prefs.setString("phone", phone.toString());
      if (email.isNotEmpty) {
        await _prefs.setString("email", email);
      }
      // Provider.of<UserData>(context, listen: false)
      //     .updateUserDetails(getDXUser(_response.body));
      Provider.of<UserData>(context, listen: false)
          .updateUserDetails(userModelFromJson(_response.body));
      getOTPFromSignup(_response.body);
      return SignInError(
        emailXPhone: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return SignInError(
        emailXPhone: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return SignInError(
        emailXPhone: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<SignInError> login(
      {required String phone,
      required String password,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"phone": phone, "password": password}),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return SignInError(
        emailXPhone: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      _prefs.setString("userMap", _response.body);
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }
      UserModel _userModel = userModelFromJson(_response.body);
      userFullName = _userModel.user.name;
      userPhone = phone.toString();
      await _prefs.setString("fullName", _userModel.user.name);
      await _prefs.setString("phone", _userModel.user.phone.toString());

      await _prefs.setString("email", _userModel.user.email);

      // Provider.of<UserData>(context, listen: false)
      //     .updateUserDetails(getDXUser(_response.body));
      Provider.of<UserData>(context, listen: false)
          .updateUserDetails(userModelFromJson(_response.body));

      return SignInError(
        emailXPhone: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return SignInError(
        emailXPhone: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return SignInError(
        emailXPhone: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> sendOTP(
      {required String phone, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone": phone,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> sendPasswordResetOTP(
      {required String phone, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone": phone,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }
      if (jsonDecode(_response.body)["otp"] != null) {
        Provider.of<UserData>(context, listen: false)
            .updateOTP(jsonDecode(_response.body)["otp"].toString());
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      }
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> verifyOTP(
      {required String phone,
      required String otp,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "phone": phone,
          "otp": otp,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> resetPassword(
      {required String newPassword,
      required String otp,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": otp,
          "password": newPassword,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updatePassword(
      {required String newPassword,
      required String oldPassword,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "old_password": oldPassword,
          "password": newPassword,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getHomeData({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/home'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateHomeData(homeDataFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getBTCTradeData({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-btc-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateBTCTradeData(btcTradeDataFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getGiftCards({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-giftcards'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateGiftCardList(giftCardModelFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getCryptoWallets({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-crypto-addresses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateBitcoinWallets(cryptoWalletAddressFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getSingleGiftCard(
      {required BuildContext context, required int id}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-giftcards/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: giftCardInfoFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getSingleGiftCountry(
      {required BuildContext context, required int id}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-giftcards/country/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: giftCardCountryFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getCryptos({required BuildContext context}) async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_apiBaseUrl/get-cryptos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print(response.body);
      }

      Provider.of<AppData>(context, listen: false)
          .updateCryptos(cryptoModelFromJson(response.body));
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: cryptoModelFromJson(response.body),
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Crypto Status Body: ${response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getBTCAddress({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-btc-random-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
          data: jsonDecode(_response.body));
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getTransactionsList(
      {required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}',
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateTrxData(transactionsListModelFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getUserTransactionsList(
      {required BuildContext context, required int userId}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/user-transactions/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}',
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: favTransactionFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getPrevTransactionsList(
      {required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/prev-transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}',
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updatePrevTrxData(transactionsListModelFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getBankList({required BuildContext context}) async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_apiBaseUrl/get-banks'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _prefs.setString("bankListMap", response.body);
      Provider.of<AppData>(context, listen: false)
          .updateBankModels(bankListModelFromJson(response.body));
      if (kDebugMode) {
        print("Bank List Status Code: ${response.statusCode}");
      }

      //todo: save bank lists

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getUserList({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/all-users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      // Provider.of<AppData>(context, listen: false)
      //     .updateHomeData(basicHomeModelFromJson(_response.body));

      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      Provider.of<AppData>(context, listen: false)
          .updateUsers(dxUserModelFromJson(_response.body));

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: dxUserModelFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getGiftCardTransaction(
      {required BuildContext context, required int id}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-giftcard-transaction/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: giftCardTrxModelFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getCryptoTransaction(
      {required BuildContext context, required int id}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-crypto-transaction/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: bitcoinTrxModelFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getWithdrawalTransaction(
      {required BuildContext context, required int id}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-single-withdrawal/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: withdrawalTrxModelFromJson(_response.body),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> acceptCryptoTransaction(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/approve-crypto-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> acceptGiftcardTransaction(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/approve-giftcard-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> acceptWithdrawal(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/approve-withdrawal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> rejectCryptoTransaction(
      {required int id,
      required String reason,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/reject-crypto-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          "rejected_reason": reason,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> rejectGiftcardTransaction(
      {required int id,
      required String reason,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/reject-giftcard-transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          "rejected_reason": reason,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> rejectWithdrawal(
      {required int id,
      required String reason,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/reject-withdrawal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          "rejected_reason": reason,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateCryptoWallet(
      {required int id,
      required int cryptoId,
      required String newAddress,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-crypto-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          "crypto_id": cryptoId,
          "address": newAddress,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: CryptoWalletAddress.fromJson(jsonDecode(_response.body)),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateCryptoRate(
      {required int cryptoId,
      required int value,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-crypto-rate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "crypto_id": cryptoId,
          "value": value,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deactivateAccount({
    required BuildContext context,
    required int id,
    required String email,
    required String phone,
  }) async {
    late http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('$_apiBaseUrl/deactivate-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode(
          {
            "user_id": id,
            "email": email,
            "phone": phone,
          },
        ),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      getHomeData(context: context);
      // Provider.of<AppData>(context, listen: false)
      //     .updateHomeData(basicHomeModelFromJson(_response.body));

      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> activateAccount({
    required BuildContext context,
    required int id,
    required String email,
    required String phone,
  }) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/activate-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode(
          {
            "user_id": id,
            "email": email,
            "phone": phone,
          },
        ),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      getHomeData(context: context);
      // Provider.of<AppData>(context, listen: false)
      //     .updateHomeData(basicHomeModelFromJson(_response.body));

      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> upgradeDowngradeUser({
    required BuildContext context,
    required int role,
    required String email,
    required String phone,
  }) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/change-user-role'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode(
          {
            "role": role,
            "email": email,
            "phone": phone,
          },
        ),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      getHomeData(context: context);
      // Provider.of<AppData>(context, listen: false)
      //     .updateHomeData(basicHomeModelFromJson(_response.body));

      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> activateCryptoWallet(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/activate-crypto-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: CryptoWalletAddress.fromJson(jsonDecode(_response.body)),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> activateGiftcard(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/activate-giftcard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deactivateGiftcard(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/deactivate-giftcard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> activateCountry(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/activate-country'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> activateRange(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/activate-range'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deactivateCountry(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/deactivate-country'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deactivateRange(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/deactivate-range'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deactivateCryptoWallet(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/deactivate-crypto-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: CryptoWalletAddress.fromJson(jsonDecode(_response.body)),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> createCryptoWallet(
      {required String address,
      required int cryptoId,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/add-crypto-address'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "address": address,
          "crypto_id": cryptoId,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateGiftcardRange(
      {required int id,
      required int gift_cards_id,
      required int gift_cards_country_id,
      required int min,
      required int max,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-country-range'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          'gift_card_id': gift_cards_id,
          'gift_card_country_id': gift_cards_country_id,
          'min': min,
          'max': max,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: GiftCardRange.fromJson(jsonDecode(_response.body)["range"]),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateGiftcardCategory(
      {required int id,
      required int giftCardsId,
      required int giftCardCountryId,
      required int rangeID,
      required int amount,
      required String title,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-giftcard-category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
          'gift_card_id': giftCardsId,
          'gift_card_country_id': giftCardCountryId,
          'amount': amount,
          'range_id': rangeID,
          'title': title,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> createGiftcardCategory({
    required int giftCardsId,
    required int giftCardCountryId,
    required int rangeID,
    required int amount,
    required String title,
    required BuildContext context,
  }) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/add-giftcard-category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          'gift_card_id': giftCardsId,
          'gift_card_country_id': giftCardCountryId,
          'amount': amount,
          'range_id': rangeID,
          'title': title,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> createGiftcardRange(
      {required int gift_cards_id,
      required int gift_cards_country_id,
      required int min,
      required int max,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/add-country-range'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          'gift_card_id': gift_cards_id,
          'gift_card_country_id': gift_cards_country_id,
          'min': min,
          'max': max,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
        data: GiftCardRange.fromJson(jsonDecode(_response.body)["range"]),
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> getCountries({required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http.get(
        Uri.parse('$_apiBaseUrl/get-countries'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
      ).timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      Provider.of<AppData>(context, listen: false)
          .updateDXCountries(dxCountryModelFromJson(_response.body));
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> createGiftcardCountry(
      {required int countryId,
      required int giftCardId,
      required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/add-giftcard-country'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          'country_id': countryId,
          'gift_card_id': giftCardId,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateBitcoinRate(
      {required int amount, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-btc-rate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          'amount': amount,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> createGiftcard(
      {required String title,
      required io.File image,
      required io.File logo,
      required BuildContext context}) async {
    var dio = Dio();
    dio.options.baseUrl = _apiBaseUrl;
    dio.options.connectTimeout = Duration(seconds: 2); //5s
    dio.options.receiveTimeout = Duration(seconds: 2);
    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization':
          'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
    };
    late Response response;
    var formData = FormData.fromMap({
      "title": title,
      "image": await MultipartFile.fromFile(image.path,
          filename: "Giftcard_$title~_Image.png"),
      "brand_logo": await MultipartFile.fromFile(logo.path,
          filename: "Giftcard_$title~_Brand_Logo_Image.png"),
    });
    try {
      response = await dio.post('$_apiBaseUrl/add-giftcard', data: formData);
    } catch (e) {
      print(e);
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
    }

    if (response.statusCode != null) {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      } else {
        return ProcessError(
          details: false,
          network: false,
          other: true,
          any: true,
        );
      }
    } else {
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateGiftcard(
      {required String title,
      required int id,
      io.File? logo,
      io.File? image,
      required bool hasLogo,
      required bool hasImage,
      required BuildContext context}) async {
    var dio = Dio();
    dio.options.baseUrl = _apiBaseUrl;
    dio.options.connectTimeout = Duration(seconds: 2); //5s
    dio.options.receiveTimeout = Duration(seconds: 2);
    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization':
          'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
    };
    late Response response;
    late var formData;

    if (hasImage && hasLogo) {
      formData = FormData.fromMap({
        "id": id,
        "title": title,
        "image": await MultipartFile.fromFile(image!.path,
            filename: "Giftcard_$title~_Image.png"),
        "brand_logo": await MultipartFile.fromFile(logo!.path,
            filename: "Giftcard_$title~_Brand_Logo_Image.png"),
      });
    } else if (hasImage && !hasLogo) {
      formData = FormData.fromMap({
        "id": id,
        "title": title,
        "image": await MultipartFile.fromFile(image!.path,
            filename: "Giftcard_$title~_Image.png"),
      });
    } else if (!hasImage && hasLogo) {
      formData = FormData.fromMap({
        "id": id,
        "title": title,
        "brand_logo": await MultipartFile.fromFile(logo!.path,
            filename: "Giftcard_$title~_Brand_Logo_Image.png"),
      });
    } else if (!hasImage && !hasLogo) {
      formData = FormData.fromMap({
        "id": id,
        "title": title,
      });
    } else {
      formData = FormData.fromMap({
        "id": id,
        "title": title,
      });
    }

    try {
      response = await dio.post('$_apiBaseUrl/update-giftcard', data: formData);
    } catch (e) {
      print(e);
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
    }

    if (response.statusCode != null) {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      } else {
        return ProcessError(
          details: false,
          network: false,
          other: true,
          any: true,
        );
      }
    } else {
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> uploadBanner(
      {required String url,
      required io.File banner,
      required BuildContext context}) async {
    var dio = Dio();
    dio.options.baseUrl = _apiBaseUrl;
    dio.options.connectTimeout = Duration(seconds: 2); //5s
    dio.options.receiveTimeout = Duration(seconds: 2);
    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization':
          'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
    };
    late Response response;
    late FormData formData;

    formData = FormData.fromMap({
      "url": url,
      "image": await MultipartFile.fromFile(banner.path,
          filename:
              "Banner_${DateTime.now().microsecondsSinceEpoch}_Image.png"),
    });

    try {
      response = await dio.post('$_apiBaseUrl/upload-banner', data: formData);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
    }

    if (response.statusCode != null) {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      } else {
        return ProcessError(
          details: false,
          network: false,
          other: true,
          any: true,
        );
      }
    } else {
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateBanner(
      {String? url,
      io.File? banner,
      required int id,
      required BuildContext context}) async {
    var dio = Dio();
    dio.options.baseUrl = _apiBaseUrl;
    dio.options.connectTimeout = Duration(seconds: 2); //5s
    dio.options.receiveTimeout = Duration(seconds: 2);
    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization':
          'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
    };
    late Response response;
    late FormData formData;

    formData = FormData.fromMap({
      "id": id,
      "url": url,
    });
    if (banner != null) {
      formData = FormData.fromMap({
        "id": id,
        "url": url,
        "image": await MultipartFile.fromFile(banner.path,
            filename:
                "Banner_${DateTime.now().microsecondsSinceEpoch}_Image.png"),
      });
    }

    try {
      response = await dio.post('$_apiBaseUrl/update-banner', data: formData);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
    }

    if (response.statusCode != null) {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      } else {
        return ProcessError(
          details: false,
          network: false,
          other: true,
          any: true,
        );
      }
    } else {
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> removeBanner(
      {required int id, required BuildContext context}) async {
    var dio = Dio();
    dio.options.baseUrl = _apiBaseUrl;
    dio.options.connectTimeout = Duration(seconds: 2); //5s
    dio.options.receiveTimeout = Duration(seconds: 2);
    dio.options.headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization':
          'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
    };
    late Response response;
    late FormData formData;

    formData = FormData.fromMap({
      "id": id,
    });

    try {
      response = await dio.post('$_apiBaseUrl/remove-banner', data: formData);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
    }

    if (response.statusCode != null) {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ProcessError(
          details: false,
          network: false,
          other: false,
          any: false,
        );
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return ProcessError(
          details: true,
          network: false,
          other: false,
          any: true,
        );
      } else {
        return ProcessError(
          details: false,
          network: false,
          other: true,
          any: true,
        );
      }
    } else {
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> updateFCM({
    required BuildContext context,
    required String token,
  }) async {
    late http.Response response;
    try {
      response = await http
          .post(
        Uri.parse('$_apiBaseUrl/update-fcm'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "fcm": token,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      Provider.of<UserData>(context, listen: false).updateFCM(token);
      // refreshWalletBalance(context: context);

      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${response.statusCode}");
        print("Status Body: ${response.body}");
      }

      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deleteCountry(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/delete-giftcard-country'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deleteWallet(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/delete-crypto-wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deleteCategory(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/delete-giftcard-category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }

  Future<ProcessError> deleteRange(
      {required int id, required BuildContext context}) async {
    late http.Response _response;
    try {
      _response = await http
          .post(
        Uri.parse('$_apiBaseUrl/delete-card-range'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${Provider.of<UserData>(context, listen: false).userModel!.token}'
        },
        body: jsonEncode({
          "id": id,
        }),
      )
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw ('Timeout Exception');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return ProcessError(
        details: false,
        network: true,
        other: false,
        any: true,
      );
    }
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
      }

      getGiftCards(context: context);
      return ProcessError(
        details: false,
        network: false,
        other: false,
        any: false,
      );
    } else if (_response.statusCode >= 400 && _response.statusCode < 500) {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: true,
        network: false,
        other: false,
        any: true,
      );
    } else {
      if (kDebugMode) {
        print("Status Code: ${_response.statusCode}");
        print("Status Body: ${_response.body}");
      }
      return ProcessError(
        details: false,
        network: false,
        other: true,
        any: true,
      );
    }
  }
}

// var localAuth = LocalAuthentication();

class SignInError {
  bool emailXPhone;
  bool network;
  bool other;
  bool any;

  SignInError({
    required this.emailXPhone,
    required this.network,
    required this.other,
    required this.any,
  });
}

class ProcessError {
  bool details;
  bool network;
  bool other;
  bool any;
  dynamic data;

  ProcessError({
    required this.details,
    required this.network,
    required this.other,
    required this.any,
    this.data,
  });
}
//
// UserModel getDXUser(String mapString) {
//   var map = jsonDecode(mapString);
//   UserModel _user = UserModel(
//     token: map["token"],
//     user: User(
//         id: map["user"]["id"],
//         name: map["user"]["name"],
//         email: map["user"]["email"],
//         phone: map["user"]["phone"],
//         photo: map["user"]["photo"],
//         role: map["user"]["role"],
//         emailVerifiedAt: map["user"]["email_verified_at"] != null
//             ? DateTime.parse(map["user"]["email_verified_at"])
//             : null,
//         phoneVerifiedAt: map["user"]["phone_verified_at"] != null
//             ? DateTime.parse(map["user"]["phone_verified_at"])
//             : null,
//         createdAt: DateTime.parse(map["user"]["created_at"]),
//         updatedAt: DateTime.parse(map["user"]["updated_at"]),
//         apiToken: map["user"]["api_token"]),
//   );
//   return _user;
// }

String? getOTPFromSignup(String mapString) {
  var map = jsonDecode(mapString);
  String? _otp = map["token"];
  return _otp;
}
