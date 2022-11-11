import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/pages/user-details.page.dart';
import 'package:faveremit_admin/select-lists/review-withdrawal.dart';
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
import '../models/withdrawal-trx-info-model.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/functions.dart';
import '../widgets/naira/naira.dart';
import '../widgets/primary-button.dart';
import '../widgets/secondary-button.dart';
import '../widgets/show-option-modal.dart';
import 'helpdesk-page.dart';

bool _gottenTrx = false;
WithdrawalTransaction? _theTransactionModel;

class WithdrawalReceiptPage extends StatefulWidget {
  // final WithdrawalItem transaction;
  final dynamic transaction;
  const WithdrawalReceiptPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  _WithdrawalReceiptPageState createState() => _WithdrawalReceiptPageState();
}

class _WithdrawalReceiptPageState extends State<WithdrawalReceiptPage> {
  _fetchTransaction() async {
    ProcessError error = await adminWorker.getWithdrawalTransaction(
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
            color: kDarkBG,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "",
          style:
              GoogleFonts.poppins(color: kDarkBG, fontWeight: FontWeight.bold),
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
                color: kDarkBG,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "The user withdrew the sum of",
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: kDarkBG,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Naira(
                                size: 26,
                                color: kPrimaryColor,
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Text(
                                NumberFormat.simpleCurrency(name: "").format(
                                    double.parse(widget.transaction.ngnAmount
                                        .toString()
                                        .replaceAll(",", ""))),
                                style: GoogleFonts.poppins(
                                    fontSize: 33,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "to ",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
                                    fontWeight: FontWeight.normal),
                                children: [
                                  // TextSpan(
                                  //   text:
                                  //       _theTransactionModel!.bank.accountName,
                                  //   style: GoogleFonts.poppins(
                                  //       fontSize: 14,
                                  //       color: kDarkBG,
                                  //       fontWeight: FontWeight.w600),
                                  // ),
                                  TextSpan(
                                    text:
                                        " (${_theTransactionModel!.bank.accountNumber.length < 10 ? "0000000000000".substring(0, 10 - _theTransactionModel!.bank.accountNumber.length) : ""}${_theTransactionModel!.bank.accountNumber}"
                                        " ~ ${_theTransactionModel!.bank.bankName}).",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: kDarkBG,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kDarkBG.withOpacity(0.02),
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
                                    color: kDarkBG,
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
                                "Account Number",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                // "₦${addCommas(_theTransactionModel!.ngnAmount)}",
                                "${_theTransactionModel!.bank.accountNumber.length < 10 ? "0000000000000".substring(0, 10 - _theTransactionModel!.bank.accountNumber.length) : ""}${_theTransactionModel!.bank.accountNumber}",
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
                                "Account Name",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.bank.accountName,
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
                                "Bank",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.bank.bankName,
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
                                "Amount",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
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
                                            _theTransactionModel!.amount
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
                                "Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: kDarkBG,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                _theTransactionModel!.createdAt
                                    .toDateTimeString()
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
                                    color: kDarkBG,
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
                                              color: kDarkBG,
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
                                              color: kDarkBG,
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
                                return ReviewWithdrawalOptionsList(
                                  trxID: widget.transaction.id,
                                  canApprove: true,
                                );
                              },
                            );
                            _fetchTransaction();
                            setState(() {});
                          },
                          title: "Review Withdrawal",
                          isActive: false,
                        )
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
              color: kDarkBG.withOpacity(0.02),
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

String _getTopSTing(int utilityID) {
  switch (utilityID) {
    case 1:
      return "You purchased airtime worth";

    case 2:
      return "You subscribed data worth";

    case 3:
      return "You purchased a TV package worth";

    case 4:
      return "You funded your electricity meter with";
    default:
      return "Your service cost";
  }
  return "";
}
