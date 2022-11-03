import 'dart:async';
import 'dart:io';

import 'package:faveremit_admin/models/crypto_wallet_address.dart';
import 'package:faveremit_admin/models/dx-user-model.dart';
import 'package:faveremit_admin/models/home-data-info.dart';
import 'package:faveremit_admin/models/transactions-object.dart';
import 'package:faveremit_admin/models/user.dart';
import 'package:faveremit_admin/pages/app-body.dart';
import 'package:faveremit_admin/pages/reviewed-transactions-page.dart';
import 'package:faveremit_admin/pages/reviewed-withdrawals-page.dart';
import 'package:faveremit_admin/pages/user-list-page.dart';
import 'package:faveremit_admin/pages/withdraw-page.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/biometric.dart';
import 'package:faveremit_admin/services-classes/push-notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import 'auth-pages/login.dart';
import 'auth-pages/recover-password-email.dart';
import 'auth-pages/returning-user-login.dart';
import 'auth-pages/signup.dart';
import 'config/dimensions.dart';
import 'config/styles.dart';
import 'firebase_options.dart';
import 'models/bank-list.dart';
import 'models/btc-trade-data.dart';
import 'models/cryptos.dart';
import 'models/dx-country-model.dart';
import 'models/gift-card-mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

AppWorker adminWorker = AppWorker();

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  void _initialize() async {
    await appBiometrics.init();
    // await dxWorker.init(context: context);
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return UserData();
        }),
        ChangeNotifierProvider(create: (context) {
          return DXConfigData();
        }),
        ChangeNotifierProvider(create: (context) {
          return AppData();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Faveremit",
        theme: ThemeData(fontFamily: "Poppins"),
        routes: {
          'splash': (context) => const SplashScreen(
                title: "Faveremit",
              ),
          // 'onBoarding': (context) => OnBoardingScreen(),
          'login': (context) => const LoginPage(),
          'return': (context) => const ReturnLoginPage(),
          'signUp': (context) => const SignUpPage(),
          'recoverPassword': (context) => const RecoverPasswordPage(),
          // 'otp': (context) => OTPVerificationPage(),
          // 'resetPassword': (context) => ResetPasswordPage(),
          // 'pinCode': (context) => PinCodeVerificationScreen(phoneNumber:,),
          "home": (context) => const AppBody(),
          "withdraw": (context) => const WithdrawPage(),

          "users": (context) => const UserListPage(),
          "r_trx": (context) => const RevTransactionsPage(),
          "r_withdrawals": (context) => const RevWithdrawalsPage(),
        },
        home: const SplashScreen(title: "Faveremit"),
      ),
    );
  }
}

class ResetPasswordPage {}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .whenComplete(() async {
      await pushNotificationsManager.init();
    });
    await adminWorker.init(context: context);
    await appBiometrics.init();

    return;
//  TODO: some other initializations will be here
  }

  @override
  void initState() {
    initializeApp().whenComplete(() {
      //check if user is previously signed in and biometrics set
      if (Provider.of<UserData>(context, listen: false).userAvailable) {
        Navigator.pushReplacementNamed(context, "return");
        // Navigator.pushReplacementNamed(context, "home");
      } else {
        // Navigator.pushReplacementNamed(context, "home");
        Navigator.pushReplacementNamed(context, "login");
        // Navigator.pushReplacementNamed(context, "return");
      }
      if (Platform.isAndroid) {
        checkForUpdate();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appSystemLightTheme,
      child: !Platform.isAndroid
          ? UpgradeAlert(
              upgrader: Upgrader(
                minAppVersion: "1.00",
                dialogStyle: UpgradeDialogStyle.cupertino,
              ),
              child: Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: kGeneralWhite),
                  child: WidgetAnimator(
                    incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
                    atRestEffect: WidgetRestingEffects.wave(),
                    outgoingEffect:
                        WidgetTransitionEffects.outgoingOffsetThenScale(),
                    child: SvgPicture.asset(
                      "assets/svg/logo-primary.svg",
                      width: screenSize.width < tabletBreakPoint
                          ? screenSize.width * 0.6
                          : 500,
                    ),
                  ),
                ),
              ),
            )
          : Scaffold(
              body: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: kGeneralWhite),
                child: WidgetAnimator(
                  incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
                  atRestEffect: WidgetRestingEffects.wave(),
                  outgoingEffect:
                      WidgetTransitionEffects.outgoingOffsetThenScale(),
                  child: SvgPicture.asset(
                    "assets/svg/logo-primary.svg",
                    width: screenSize.width < tabletBreakPoint
                        ? screenSize.width * 0.6
                        : 500,
                  ),
                ),
              ),
            ),
    );
  }
}

Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info) {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }
  }).catchError((e) {
    if (kDebugMode) {
      print(e);
    }
  });
}

// void showSnack(String text) {
//   if (_scaffoldKey.currentContext != null) {
//     ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//         .showSnackBar(SnackBar(content: Text(text)));
//   }
// }

class DXConfigData with ChangeNotifier, DiagnosticableTreeMixin {
  bool signingUp = false;
  bool loggingIn = false;

  updateSignUpState(bool newStatus) {
    signingUp = newStatus;
    notifyListeners();
  }

  updateLoginState(bool newStatus) {
    loggingIn = newStatus;
    notifyListeners();
  }
}

class UserData with ChangeNotifier, DiagnosticableTreeMixin {
  UserModel? userModel;
  bool userAvailable = false;
  bool useBiometrics = false;
  String? otp;

  String? fcm;
  bool fcmUpdated = false;
  updateFCM(String newFCM) {
    fcm = newFCM;
    fcmUpdated = true;
    notifyListeners();
  }

  updateUserDetails(UserModel updatedUserDetails) {
    userModel = updatedUserDetails;
    userAvailable = true;
    notifyListeners();
  }

  updateUseBiometric(bool newValue) {
    useBiometrics = newValue;
    notifyListeners();
  }

  updateOTP(String newOTP) {
    otp = newOTP;
    notifyListeners();
  }

  clearOTP() {
    otp = null;
  }

  clearAll() {
    userAvailable = false;
    useBiometrics = false;
    userModel = null;
    notifyListeners();
  }
}

class AppData with ChangeNotifier, DiagnosticableTreeMixin {
  HomeData? homeDataModel;
  bool homeDataAvailable = false;

  updateHomeData(HomeData newData) {
    homeDataModel = newData;
    homeDataAvailable = true;
    notifyListeners();
  }

  TransactionsListModel? transactionsListModel;
  bool trxListAvailable = false;

  updateTrxData(TransactionsListModel newData) {
    transactionsListModel = newData;
    trxListAvailable = true;
    notifyListeners();
  }

  //Previous Trx List
  TransactionsListModel? prevTransactionsListModel;

  updatePrevTrxData(TransactionsListModel newData) {
    prevTransactionsListModel = newData;
    notifyListeners();
  }

  //Bank List
  BankListModel? bankListModel;
  bool banksAvailable = false;

  updateBankModels(BankListModel newBankListModel) {
    bankListModel = newBankListModel;
    banksAvailable = true;
    notifyListeners();
  }

  BtcTradeData? btcTradeData;

  updateBTCTradeData(BtcTradeData newData) {
    btcTradeData = newData;
    notifyListeners();
  }

  List<GiftCardModel>? giftCardList;

  updateGiftCardList(List<GiftCardModel> newList) {
    giftCardList = newList;
    notifyListeners();
  }

  List<CryptoWalletAddress>? cryptoWallets;

  updateBitcoinWallets(List<CryptoWalletAddress> newList) {
    cryptoWallets = newList;
    notifyListeners();
  }

  List<CryptoModel>? cryptos;

  updateCryptos(List<CryptoModel> newList) {
    cryptos = newList;
    notifyListeners();
  }

  List<DxCountryModel>? dxCountries;

  updateDXCountries(List<DxCountryModel> newList) {
    dxCountries = newList;
    notifyListeners();
  }

  List<DxUserModel>? users;

  updateUsers(List<DxUserModel> newList) {
    users = newList;

    notifyListeners();
  }
}
