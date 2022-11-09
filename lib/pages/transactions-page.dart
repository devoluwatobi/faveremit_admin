import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../widgets/persistent-slide-control-delegate.dart';
import '../widgets/show-option-modal.dart';
import '../widgets/transaction-card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

late RefreshController _refreshController;

class _TransactionsPageState extends State<TransactionsPage> {
  _refreshTransactions() async {
    ProcessError _response =
        await adminWorker.getTransactionsList(context: context);
    ;
    setState(() {});
    if (_response.any) {
      bool? temp = await showSingleOptionPopup(
          context: context,
          title: "Oops!",
          body:
              "Unable update transactions list please check your internet and try again",
          actionTitle: "Retry",
          onPressed: () {
            Navigator.pop(context, true);
            _refreshTransactions();
          },
          isDestructive: false);
    } else {
      setState(() {});
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    ProcessError _response =
        await adminWorker.getTransactionsList(context: context);
    setState(() {});
    if (_response.any) {
      _refreshController.refreshFailed();
    } else {
      setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _refreshTransactions();
    super.initState();
  }

  int _flexTranTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kAppHorizontalPadding,
      alignment: Alignment.center,
      child: SmartRefresher(
        header: const WaterDropHeader(),
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // SliverPersistentHeader(delegate: delegate)
            SliverPersistentHeader(
              pinned: true,
              delegate: AppPersistentSlideControlDelegate(
                widget: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.width < tabletBreakPoint
                          ? 20
                          : screenSize.width * 0.04),
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl(
                    onValueChanged: (newValue) {
                      setState(() {
                        _flexTranTab = int.parse(newValue.toString());
                        // _tasksController.animateToPage(newValue,
                        //     duration: Duration(milliseconds: 300),
                        //     curve: Curves.easeInOut);
                      });
                    },
                    groupValue: _flexTranTab,
                    children: {
                      0: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.width < tabletBreakPoint
                                ? 7.5
                                : screenSize.width * 0.015),
                        child: Text(
                          "Gift Card",
                          style: TextStyle(
                            color:
                                _flexTranTab == 0 ? kPrimaryColor : kTextGray,
                            fontWeight: _flexTranTab == 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      1: Text(
                        "Crypto",
                        style: TextStyle(
                          color: _flexTranTab == 1 ? kPrimaryColor : kTextGray,
                          fontWeight: _flexTranTab == 1
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      2: Text(
                        "Withdrawals",
                        style: TextStyle(
                          color: _flexTranTab == 2 ? kPrimaryColor : kTextGray,
                          fontWeight: _flexTranTab == 2
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            ),
            Provider.of<AppData>(context).trxListAvailable
                ? getTrxList(
                    tabID: _flexTranTab,
                    context: context,
                  )
                : SliverToBoxAdapter(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.3),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      enabled: true,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width < tabletBreakPoint
                                          ? 20
                                          : screenSize.width * 0.04),
                                  color: kGeneralWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF606470)
                                          .withOpacity(.1),
                                      offset: const Offset(0, 5),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                    )
                                  ]),
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                  screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02),
                              margin: EdgeInsets.symmetric(
                                  vertical: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      screenSize.width < tabletBreakPoint
                                          ? 10
                                          : screenSize.width * 0.02,
                                    ),
                                    height: screenSize.width < tabletBreakPoint
                                        ? 60
                                        : screenSize.width * 0.12,
                                    width: screenSize.width < tabletBreakPoint
                                        ? 60
                                        : screenSize.width * 0.12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6E9D8),
                                      borderRadius: BorderRadius.circular(
                                          screenSize.width < tabletBreakPoint
                                              ? 10
                                              : screenSize.width * 0.02),
                                    ),
                                    child: Image.asset(
                                      "assets/3d/coin.png",
                                      errorBuilder: (context, x, y) {
                                        return Icon(
                                          FlutterRemix.bit_coin_fill,
                                          size: 40,
                                          color: kPrimaryColor,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "500 USD",
                                          style: trxTitleTextStyle,
                                        ),
                                        SizedBox(
                                          height: screenSize.width <
                                                  tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                        ),
                                        Text(
                                          "03:42 PM Today",
                                          style: trxDateTextStyle,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₦32,000.00",
                                        style: trxAmountTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "Completed",
                                        style: GoogleFonts.poppins(
                                            color: kGreen,
                                            fontSize: screenSize.width <
                                                    tabletBreakPoint
                                                ? 14
                                                : 18,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Pending",
                                      style: GoogleFonts.poppins(
                                          color: kYellow,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Failed",
                                      style: GoogleFonts.poppins(
                                          color: kRed,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                    errorBuilder: (context, x, y) {
                                      return Icon(
                                        FlutterRemix.bit_coin_fill,
                                        size: 40,
                                        color: kPrimaryColor,
                                      );
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Completed",
                                      style: GoogleFonts.poppins(
                                          color: kGreen,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Pending",
                                      style: GoogleFonts.poppins(
                                          color: kYellow,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Failed",
                                      style: GoogleFonts.poppins(
                                          color: kRed,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                    errorBuilder: (context, x, y) {
                                      return Icon(
                                        FlutterRemix.bit_coin_fill,
                                        size: 40,
                                        color: kPrimaryColor,
                                      );
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Completed",
                                      style: GoogleFonts.poppins(
                                          color: kGreen,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Pending",
                                      style: GoogleFonts.poppins(
                                          color: kYellow,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Failed",
                                      style: GoogleFonts.poppins(
                                          color: kRed,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                    errorBuilder: (context, x, y) {
                                      return Icon(
                                        FlutterRemix.bit_coin_fill,
                                        size: 40,
                                        color: kPrimaryColor,
                                      );
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Completed",
                                      style: GoogleFonts.poppins(
                                          color: kGreen,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Pending",
                                      style: GoogleFonts.poppins(
                                          color: kYellow,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                color: kGeneralWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF606470).withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                  )
                                ]),
                            width: double.infinity,
                            padding: EdgeInsets.all(
                                screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 10
                                    : screenSize.width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 10
                                        : screenSize.width * 0.02,
                                  ),
                                  height: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  width: screenSize.width < tabletBreakPoint
                                      ? 60
                                      : screenSize.width * 0.12,
                                  child: Image.asset(
                                    "assets/3d/coin.png",
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6E9D8),
                                    borderRadius: BorderRadius.circular(
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : screenSize.width * 0.02,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "500 USD",
                                        style: trxTitleTextStyle,
                                      ),
                                      SizedBox(
                                        height:
                                            screenSize.width < tabletBreakPoint
                                                ? 5
                                                : screenSize.width * 0.01,
                                      ),
                                      Text(
                                        "03:42 PM Today",
                                        style: trxDateTextStyle,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₦32,000.00",
                                      style: trxAmountTextStyle,
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 5
                                              : screenSize.width * 0.01,
                                    ),
                                    Text(
                                      "Failed",
                                      style: GoogleFonts.poppins(
                                          color: kRed,
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 14
                                              : 18,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTrxList({required BuildContext context, required int tabID}) {
  switch (tabID) {
    case 0:
      if (Provider.of<AppData>(context)
          .transactionsListModel!
          .giftCards
          .isNotEmpty) {
        return SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TransactionItem(
                transaction: Provider.of<AppData>(context)
                    .transactionsListModel!
                    .giftCards[index]);
          },
          childCount: Provider.of<AppData>(context)
              .transactionsListModel!
              .giftCards
              .length,
        ));
      }
      break;

    case 1:
      if (Provider.of<AppData>(context)
          .transactionsListModel!
          .bitcoins
          .isNotEmpty) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TransactionItem(
                  transaction: Provider.of<AppData>(context)
                      .transactionsListModel!
                      .bitcoins[index]);
            },
            childCount: Provider.of<AppData>(context)
                .transactionsListModel!
                .bitcoins
                .length,
          ),
        );
      }
      break;

    case 2:
      if (Provider.of<AppData>(context)
          .transactionsListModel!
          .withdrawals
          .isNotEmpty) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TransactionItem(
                  transaction: Provider.of<AppData>(context)
                      .transactionsListModel!
                      .withdrawals[index]);
            },
            childCount: Provider.of<AppData>(context)
                .transactionsListModel!
                .withdrawals
                .length,
          ),
        );
      }

      break;

    default:
      return SliverToBoxAdapter(
        child: Column(
          children: [
            Lottie.asset(
              "assets/lottie/empty.json",
              errorBuilder: (context, x, y) {
                return Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kInactive,
                  ),
                  child: Icon(
                    FlutterRemix.newspaper_fill,
                    color: kGeneralWhite,
                    size: 50,
                  ),
                );
              },
              height: screenSize.width * (2 / 3),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "User's Transactions will appear here as soon as they make them",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: kTextGray),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
  }
  return SliverToBoxAdapter(
    child: Column(
      children: [
        Lottie.asset(
          "assets/lottie/empty.json",
          errorBuilder: (context, x, y) {
            return Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: kInactive,
              ),
              child: Icon(
                FlutterRemix.newspaper_fill,
                color: kGeneralWhite,
                size: 50,
              ),
            );
          },
          height: screenSize.width * (2 / 3),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "User's Transactions will appear here as soon as they make them",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 18, color: kTextGray),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
