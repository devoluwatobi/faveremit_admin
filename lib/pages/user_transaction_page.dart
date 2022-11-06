import 'dart:async';

import 'package:drop_shadow/drop_shadow.dart' as ds;
import 'package:faveremit_admin/config/dimensions.dart';
import 'package:faveremit_admin/config/styles.dart';
import 'package:faveremit_admin/extensions/to_shimmer.dart';
import 'package:faveremit_admin/models/user_transaction-list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../main.dart';
import '../../widgets/show-option-modal.dart';
import '../models/dx-user-model.dart';
import '../services-classes/app-worker.dart';
import '../widgets/user_transaction-card.dart';

late Timer _periodicSyncTimer;
ProcessError? _ratesResponse;
late RefreshController _refreshController;
List<UserFavTransaction>? _transactions;

class UserTransactions extends StatefulWidget {
  FavUserModel user;
  UserTransactions({Key? key, required this.user}) : super(key: key);

  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  void _onRefresh() async {
    // monitor network fetch
    _ratesResponse = await adminWorker.getUserTransactionsList(
      context: context,
      userId: widget.user.id,
    );
    setState(() {});
    if (_ratesResponse!.any) {
      _refreshController.refreshFailed();
    } else {
      _transactions = _ratesResponse!.data;
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

  _refreshTransactions() async {
    _ratesResponse = await adminWorker.getUserTransactionsList(
      context: context,
      userId: widget.user.id,
    );
    setState(() {});
    if (_ratesResponse!.any) {
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
      if (temp == null && _transactions != null) {
        Navigator.pop(
          context,
        );
      }
    } else {
      _transactions = _ratesResponse!.data;
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (_periodicSyncTimer.isActive) {
      _periodicSyncTimer.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    _transactions = null;
    _refreshController = RefreshController(initialRefresh: false);
    _refreshTransactions();

    _periodicSyncTimer =
        Timer.periodic(const Duration(seconds: 120), (Timer t) async {
      if (kDebugMode) {
        print("Periodic Tasks");
      }
      //simpleTask will be emitted here.

      await adminWorker.getTransactionsList(context: context);
      // return Future.value(_result);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Transactions",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.w500),
        ),
        backgroundColor: kGeneralWhite,
        foregroundColor: kGeneralWhite,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: kTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kGeneralWhite,
      body: Consumer<AppData>(
        builder: (context, appData, child) {
          return SizedBox(
            child: _transactions == null
                ? const _DummyVersion().toShimmer()
                : _transactions!.isNotEmpty
                    ? SmartRefresher(
                        header: const WaterDropHeader(),
                        enablePullDown: true,
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        // physics: const BouncingScrollPhysics(),
                        child: ListView.builder(
                          padding: kAppHorizontalPadding,
                          // physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              FavUserTransactionCard(
                            transaction: _transactions![index],
                          ),
                          itemCount: _transactions!.length,
                        ),
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset("assets/lottie/empty.json"),
                          const SizedBox(height: 20),
                          Text("Transaction List is empty",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: kTextGray)),
                        ],
                      )),
          );
        },
      ),
    );
  }
}

class _DummyVersion extends StatelessWidget {
  const _DummyVersion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: kAppHorizontalPadding,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/btc.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/eth.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/usdt.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                borderRadius: 20,
                child: Image.asset(
                  "assets/images/airtel.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Airtime",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦400.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Completed",
                    style: GoogleFonts.poppins(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                borderRadius: 20,
                child: Image.asset(
                  "assets/service-icons/withdraw.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Withdrawal",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦400.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Completed",
                    style: GoogleFonts.poppins(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/btc.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/eth.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                child: Image.asset(
                  "assets/3d/usdt.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "500 USD",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦32,000.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                        color: kYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kFormBG,
            // boxShadow: [
            //   BoxShadow(
            //     color: const Color(0xFF606470).withOpacity(.1),
            //     offset: const Offset(0, 5),
            //     spreadRadius: 0,
            //     blurRadius: 20,
            //   )
            // ],
          ),
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              ds.DropShadow(
                offset: const Offset(0, 3),
                blurRadius: 2,
                spread: 0,
                opacity: .3,
                borderRadius: 20,
                child: Image.asset(
                  "assets/images/airtel.png",
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Airtime",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kTextPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "03:42 PM Today",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: kTextGray),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₦400.00",
                    style: GoogleFonts.poppins(
                        color: kTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Completed",
                    style: GoogleFonts.poppins(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color getStatusColor(String status) {
  String lowCase = status.toLowerCase();
  if (lowCase.contains("complete")) {
    return kGreen;
  } else if (lowCase.contains("approved")) {
    return kGreen;
  } else if (lowCase.contains("review")) {
    return kYellow;
  } else if (lowCase.contains("pending")) {
    return kYellow;
  } else if (lowCase.contains("fail")) {
    return kRed;
  } else if (lowCase.contains("cancel")) {
    return kTextGray;
  } else if (lowCase.contains("reject")) {
    return kRed;
  } else if (lowCase.contains("3")) {
    return kRed;
  } else {
    return kYellow;
  }
}
