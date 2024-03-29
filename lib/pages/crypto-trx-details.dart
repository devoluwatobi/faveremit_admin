import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/pages/user-details.page.dart';
import 'package:faveremit_admin/select-lists/review-btc-trx.dart';
import 'package:faveremit_admin/widgets/naira/naira.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/bitcoin-trx-info-model.dart';
import '../models/transactions-object.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/functions.dart';
import '../widgets/primary-button.dart';
import '../widgets/secondary-button.dart';
import '../widgets/show-option-modal.dart';
import 'ProductImageView.dart';
import 'helpdesk-page.dart';

bool _gottenTrx = false;
CryptoTransaction? _theTransactionModel;

class BTCTrxReceiptPage extends StatefulWidget {
  final FavTransaction transaction;
  const BTCTrxReceiptPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  _BTCTrxReceiptPageState createState() => _BTCTrxReceiptPageState();
}

class _BTCTrxReceiptPageState extends State<BTCTrxReceiptPage> {
  _fetchTransaction() async {
    ProcessError error = await adminWorker.getCryptoTransaction(
        context: context, id: widget.transaction.id);
    if (error.any) {
      bool? temp = await showSingleOptionPopup(
          context: context,
          title: "Oops!",
          body: error.network
              ? "Faveremit could not connect to the internet. Please check your connection and try again"
              : error.details
                  ? "Please confirm your password and try again"
                  : "We could not fetch transaction details successfully. Please try again",
          actionTitle: "Retry",
          isDestructive: false,
          onPressed: () {
            Navigator.pop(context);
            _fetchTransaction();
          });
      if (temp == null) {
        Navigator.pop(
          context,
        );
      }
    } else {
      _theTransactionModel = error.data.transaction;
      setState(() {
        _gottenTrx = true;
      });
    }
  }

  @override
  void initState() {
    _gottenTrx = false;
    _fetchTransaction();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGeneralWhite,
        foregroundColor: kGeneralWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: kTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const HelpDeskPage()));
              },
              icon: Icon(
                FlutterRemix.customer_service_2_fill,
                color: kTextPrimary,
              ))
        ],
      ),
      backgroundColor: kGeneralWhite,
      body: SafeArea(
        child: !_gottenTrx
            ? const _PageShimmer()
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: kAppHorizontalPadding,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Crypto Transaction Details",
                        style: kSubTitleStyle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint
                            ? 10
                            : screenSize.width * 0.026,
                      ),
                      Text(
                        _theTransactionModel!.status
                                .toLowerCase()
                                .contains("pend")
                            ? "Transaction is pending while we confirm your bitcoin trade details."
                            : "Transaction details for a previous bitcoin trade.",
                        style: kSubTextStyle,
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint
                            ? 40
                            : screenSize.width * 0.1,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kTextPrimary.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE8EBF3),
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Transaction ID",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.transactionRef,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: kDarkBG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Crypto",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.cryptoName,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: kDarkBG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wallet Type",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.walletType,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: kDarkBG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Crypto Value",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${_theTransactionModel!.cryptoAmount}${_theTransactionModel!.cryptoShortCode}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: kDarkBG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Receiving Address",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _theTransactionModel!.walletAddress,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: kDarkBG,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "USD Value",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "\$${_theTransactionModel!.usdAmount}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: kDarkBG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rate",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  Naira(
                                    size: 11,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    "${NumberFormat.simpleCurrency(name: "").format(double.parse(_theTransactionModel!.usdRate.toString().replaceAll(",", "")))}/\$",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: kDarkBG,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Naira Value",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  Naira(
                                    size: 11,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    NumberFormat.simpleCurrency(name: "")
                                        .format(double.parse(
                                            _theTransactionModel!.ngnAmount
                                                .toString()
                                                .replaceAll(",", ""))),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: kDarkBG,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFE8EBF3),
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kTextPrimary,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: _theTransactionModel!.status
                                            .toLowerCase()
                                            .contains("pend")
                                        ? kYellow
                                        : _theTransactionModel!.status
                                                .toLowerCase()
                                                .contains("cancel")
                                            ? kPurple
                                            : _theTransactionModel!.status
                                                    .toLowerCase()
                                                    .contains("complete")
                                                ? kGreen
                                                : _theTransactionModel!.status
                                                        .toLowerCase()
                                                        .contains("fail")
                                                    ? kRed
                                                    : kDarkBG,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  _theTransactionModel!.status,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: kGeneralWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _theTransactionModel!.approvedBy != null ||
                                _theTransactionModel!.rejectedBy != null
                            ? Column(
                                children: [
                                  const Divider(
                                    thickness: 1,
                                    color: Color(0xFFE8EBF3),
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reviewed at",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: kTextPrimary,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          _theTransactionModel!.updatedAt
                                              .toDateTimeString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: kDarkBG,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Color(0xFFE8EBF3),
                                    height: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${_theTransactionModel!.approvedBy != null ? "Approved" : "Rejected"} By",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: kTextPrimary,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          _theTransactionModel!.approvedBy ==
                                                      0 ||
                                                  _theTransactionModel!
                                                          .rejectedBy ==
                                                      0 ||
                                                  Provider.of<AppData>(context)
                                                          .users ==
                                                      null
                                              ? "User ~ ${_theTransactionModel!.approvedBy ?? _theTransactionModel!.rejectedBy}"
                                              : Provider.of<AppData>(context)
                                                  .users!
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      int.parse((_theTransactionModel!
                                                                  .approvedBy ??
                                                              _theTransactionModel!
                                                                  .rejectedBy)
                                                          .toString()))
                                                  .name
                                                  .inTitleCase,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: kDarkBG,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductImageView(
                                productImage:
                                    NetworkImage(_theTransactionModel!.proof),
                                pageController: PageController(initialPage: 0),
                                isGallery: false,
                                gallery: [
                                  _theTransactionModel!.proof,
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFE8EBF3),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(4),
                            color: kGeneralWhite,
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Transaction Proof Image",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: kDarkBG),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: kDarkBG.withOpacity(0.1),
                                    ),
                                    width: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: _theTransactionModel!.proof,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _theTransactionModel!.status
                              .toString()
                              .toLowerCase()
                              .contains("fail")
                          ? kYellow.withOpacity(.1)
                          : Color(0xFFC8F6FB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 16),
                    child: Text(
                      _theTransactionModel!.status
                              .toLowerCase()
                              .contains("fail")
                          ? _theTransactionModel!.rejectedReason.toString()
                          : "Happy Trading",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _theTransactionModel!.status
                                .toString()
                                .toLowerCase()
                                .contains("fail")
                            ? kYellow
                            : const Color(0xFF00878F),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  !_theTransactionModel!.status
                              .toLowerCase()
                              .contains("cancel") &&
                          !_theTransactionModel!.status
                              .toLowerCase()
                              .contains("complete") &&
                          !_theTransactionModel!.status
                              .toLowerCase()
                              .contains("fail")
                      ? PrimaryTextButton(
                          onPressed: () async {
                            await showCupertinoModalBottomSheet(
                              context: context,
                              expand: false,
                              barrierColor:
                                  const Color(0xFF000000).withOpacity(0.6),
                              builder: (context) {
                                return ReviewBitcoinTrxOptionsList(
                                  trxID: widget.transaction.id,
                                  canApprove: true,
                                );
                              },
                            );
                            _fetchTransaction();
                            setState(() {});
                          },
                          title: "Review Transaction",
                          isActive: false,
                        ).showOrHide(
                          Provider.of<UserData>(context, listen: false)
                                      .userModel!
                                      .user
                                      .role !=
                                  null &&
                              (Provider.of<UserData>(context, listen: false)
                                          .userModel!
                                          .user
                                          .role! ==
                                      1 ||
                                  Provider.of<UserData>(context, listen: false)
                                          .userModel!
                                          .user
                                          .role! ==
                                      2))
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  SecondaryTextButton(
                      onPressed: () async {
                        if (Provider.of<AppData>(context, listen: false)
                            .users!
                            .any((element) =>
                                element.id == _theTransactionModel!.userId)) {
                          await showCupertinoModalBottomSheet(
                            context: context,
                            expand: false,
                            barrierColor:
                                const Color(0xFF000000).withOpacity(0.6),
                            builder: (context) {
                              return UserDetailsPage(
                                  user: Provider.of<AppData>(context,
                                          listen: false)
                                      .users!
                                      .firstWhere((element) =>
                                          element.id ==
                                          _theTransactionModel!.userId));
                            },
                          );
                        }
                      },
                      title: "View User's Profile"),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _theTransactionModel = null;
    _gottenTrx = false;
    super.dispose();
  }
}

class _PageShimmer extends StatelessWidget {
  const _PageShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kTextGray.withOpacity(0.3),
      highlightColor: kTextGray.withOpacity(0.1),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: kAppHorizontalPadding,
        children: [
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: kTextPrimary.withOpacity(0.02),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFFE8EBF3),
                  width: 1,
                  style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transaction ID",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kDarkBG,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "665784836UY4",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kDarkBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFE8EBF3),
                  height: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kDarkBG,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "₦70,000,000",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kDarkBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFE8EBF3),
                  height: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transaction Rate",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kDarkBG,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "570/\$",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kDarkBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFE8EBF3),
                  height: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Type",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kDarkBG,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Gift Card",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kDarkBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xFFE8EBF3),
                  height: 1,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kDarkBG,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "In Progress",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kDarkBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFFE8EBF3),
                      width: 1,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4),
                  color: kGeneralWhite,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset("assets/svg/payment_proof.svg"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Tap to upload Payment Proof",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: kDarkBG),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please ensure that the card number is clearly visible and in focus along with other items in the photo you are about to submit",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: kTextGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          SecondaryTextButton(
            onPressed: () async {},
            title: "Cancel Transaction",
            isActive: false,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
