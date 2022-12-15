import 'dart:async';

import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/pages/create-giftcard-page.dart';
import 'package:faveremit_admin/pages/create-wallet-page.dart';
import 'package:faveremit_admin/pages/rates-page.dart';
import 'package:faveremit_admin/pages/transactions-page.dart';
import 'package:faveremit_admin/pages/wallets-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/drawer-navigation.dart';
import '../services-classes/push-notifications.dart';
import '../widgets/app-fab.dart';
import 'drawer.dart';
import 'home-page.dart';

int pageIndex = 0;

PageController clientBodyPageController = PageController(
  initialPage: pageIndex,
);
late Timer periodicSyncTimer;

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  _updateAppData() async {
    adminWorker.getHomeData(context: context);
    adminWorker.getTransactionsList(context: context);
    adminWorker.getPrevTransactionsList(context: context);
    adminWorker.getUserList(context: context);
    adminWorker.getCryptoWallets(context: context);
    adminWorker.getGiftCards(context: context);
    adminWorker.getCryptos(context: context);
    if (!Provider.of<UserData>(context, listen: false).fcmUpdated) {
      adminWorker.updateFCM(
          context: context, token: pushNotificationsManager.token!);
    }
  }

  @override
  void initState() {
    _updateAppData();

    periodicSyncTimer =
        Timer.periodic(const Duration(seconds: 20), (Timer t) async {
      if (kDebugMode) {
        print("background task started");
      }

      if (kDebugMode) {
        print("task syncopate");
      }

      _updateAppData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: appSystemLightTheme,
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: kGeneralWhite,
            appBar: AppBar(
              leading: pageIndex == 0
                  ? GestureDetector(
                      onTap: () async {
                        Navigator.of(context)
                            .push(drawerRoute(const DrawerPage()));
                      },
                      child: Icon(
                        FlutterRemix.menu_2_line,
                        color: kTextPrimary,
                      ),
                    )
                  : null,
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: kGeneralWhite,
              elevation: 0,
              title: pageIndex == 0
                  ? SvgPicture.asset(
                      "assets/logos/logo-primary.svg",
                      width: screenSize.width < tabletBreakPoint
                          ? screenSize.width * 0.2
                          : 105,
                    )
                  : Text(
                      pageIndex == 1
                          ? "Transactions"
                          : pageIndex == 2
                              ? "Rates"
                              : "Crypto Wallets",
                      style: GoogleFonts.poppins(
                          color: kTextPrimary, fontWeight: FontWeight.w500),
                    ),
              actions: pageIndex == 0
                  ? [
                      Icon(
                        FlutterRemix.notification_4_fill,
                        color: kTextPrimary,
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ]
                  : null,
            ),
            body: PageView(
              physics: const BouncingScrollPhysics(),
              controller: clientBodyPageController,
              onPageChanged: (newPageIndexIndex) {
                setState(() {
                  pageIndex = newPageIndexIndex;
                });
              },
              children: const [
                HomePage(),
                TransactionsPage(),
                RatesPage(),
                WalletsPage(),
              ],
            ),
            floatingActionButton: pageIndex == 2
                ? AppFAB(
                    leading: Icon(
                      FlutterRemix.add_fill,
                      color: kGeneralWhite,
                    ),
                    title: "Add New Card",
                    onTap: () async {
                      await showCupertinoModalBottomSheet(
                        context: context,
                        expand: false,
                        barrierColor: const Color(0xFF000000).withOpacity(0.6),
                        builder: (context) {
                          return const CreateGiftcardPage();
                        },
                      );
                    },
                  ).showOrHide(Provider.of<UserData>(context, listen: false)
                            .userModel!
                            .user
                            .role !=
                        null &&
                    (Provider.of<UserData>(context, listen: false)
                            .userModel!
                            .user
                            .role! ==
                        1))
                : pageIndex == 3
                    ? AppFAB(
                        leading: Icon(
                          FlutterRemix.add_fill,
                          color: kGeneralWhite,
                        ),
                        title: "New Wallet",
                        onTap: () {
                          showCupertinoModalBottomSheet(
                              barrierColor: Colors.black.withOpacity(0.8),
                              context: context,
                              builder: (context) => const CreateWalletPage());
                        },
                      ).showOrHide(Provider.of<UserData>(context, listen: false)
                                .userModel!
                                .user
                                .role !=
                            null &&
                        (Provider.of<UserData>(context, listen: false)
                                .userModel!
                                .user
                                .role! ==
                            1))
                    : const SizedBox(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 5,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: kInactive,
              currentIndex: pageIndex,
              unselectedLabelStyle: TextStyle(
                color: kInactive,
                fontSize: screenSize.width < tabletBreakPoint
                    ? screenSize.width * 0.035
                    : 18,
                fontWeight: FontWeight.w500,
              ),
              selectedLabelStyle: TextStyle(
                color: kPrimaryColor,
                fontSize: screenSize.width < tabletBreakPoint
                    ? screenSize.width * 0.035
                    : 18,
                fontWeight: FontWeight.w600,
              ),
              onTap: (newPageIndex) {
                setState(() {
                  pageIndex = newPageIndex;
                  clientBodyPageController.animateToPage(newPageIndex,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.home_smile_fill), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.file_list_3_fill),
                    label: "Transactions"),
                BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.swap_fill), label: "Rates"),
                BottomNavigationBarItem(
                    icon: Icon(FlutterRemix.wallet_fill), label: "Wallets"),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    periodicSyncTimer.cancel();
    super.dispose();
  }
}
