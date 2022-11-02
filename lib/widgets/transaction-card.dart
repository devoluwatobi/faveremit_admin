import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/pages/withdrawal-request-info-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../models/transactions-object.dart';
import '../pages/crypto-trx-details.dart';
import '../pages/gift-card-trx-details-page.dart';
import '../services-classes/functions.dart';

class TransactionItem extends StatefulWidget {
  final FavTransaction transaction;
  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

var format = DateFormat("hh:mm");

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.transaction.type.toString().toLowerCase().contains("gift")) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => GTrxReceiptPage(
                        transaction: widget.transaction,
                      )));
        } else if (widget.transaction.type
            .toString()
            .toLowerCase()
            .contains("crypto")) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BTCTrxReceiptPage(
                        transaction: widget.transaction,
                      )));
        } else if (widget.transaction.type
            .toString()
            .toLowerCase()
            .contains("wallet")) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => WithdrawalReceiptPage(
                        transaction: widget.transaction,
                      )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                screenSize.width < tabletBreakPoint
                    ? 20
                    : screenSize.width * 0.04),
            color: kGeneralWhite,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF606470).withOpacity(.1),
                offset: const Offset(0, 5),
                spreadRadius: 0,
                blurRadius: 20,
              )
            ]),
        width: double.infinity,
        padding: EdgeInsets.all(
            screenSize.width < tabletBreakPoint ? 10 : screenSize.width * 0.02),
        margin: EdgeInsets.symmetric(
            vertical: screenSize.width < tabletBreakPoint
                ? 6
                : screenSize.width * 0.012),
        child: Row(
          children: [
            widget.transaction.serviceId.toString() == 0.toString()
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                        screenSize.width < tabletBreakPoint
                            ? 10
                            : screenSize.width * 0.02),
                    child: Container(
                      padding: const EdgeInsets.all(
                        0,
                      ),
                      height: screenSize.width < tabletBreakPoint
                          ? 40
                          : screenSize.width * 0.12,
                      width: screenSize.width < tabletBreakPoint
                          ? 40
                          : screenSize.width * 0.12,
                      decoration: BoxDecoration(
                        color: widget.transaction.serviceId.toString() ==
                                2.toString()
                            ? const Color(0xFFF6E9D8)
                            : widget.transaction.serviceId.toString() ==
                                    1.toString()
                                ? const Color(0xFFF5E1FD)
                                : widget.transaction.status == 1
                                    ? kGreenLight
                                    : widget.transaction.status == 3
                                        ? kRedLight
                                        : widget.transaction.status == 2
                                            ? kRedLight
                                            : const Color(0xFFECEEFB),
                        borderRadius: BorderRadius.circular(
                            screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.02),
                      ),
                      child: Icon(
                        FlutterRemix.arrow_down_fill,
                        color: widget.transaction.status == 1
                            ? kGreen
                            : widget.transaction.status == 3
                                ? kPurple
                                : widget.transaction.status == 2
                                    ? kRed
                                    : kPrimaryColor,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                        screenSize.width < tabletBreakPoint
                            ? 10
                            : screenSize.width * 0.02),
                    child: Container(
                      padding: const EdgeInsets.all(
                        0,
                      ),
                      height: screenSize.width < tabletBreakPoint
                          ? 60
                          : screenSize.width * 0.12,
                      width: screenSize.width < tabletBreakPoint
                          ? 60
                          : screenSize.width * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.02),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.transaction.icon.toString(),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorWidget: (context, a, b) {
                          if (widget.transaction.serviceId.toString() ==
                              2.toString()) {
                            return Image.asset(
                              "assets/3d/bitcoin.png",
                              height: 60,
                              width: 60,
                            );
                          } else if (widget.transaction.serviceId.toString() ==
                              1.toString()) {
                            return Image.asset(
                              "assets/3d/giftcard.png",
                              height: 60,
                              width: 60,
                            );
                          } else {
                            return Image.asset(
                              "assets/3d/bills.png",
                              height: 60,
                              width: 60,
                            );
                          }
                        },
                      ),
                    ),
                  ),
            SizedBox(
              width: screenSize.width < tabletBreakPoint
                  ? 10
                  : screenSize.width * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Todo: fix the transactions UI
                  Text(
                    widget.transaction.title.toString(),
                    style: GoogleFonts.poppins(
                      color: kTextPrimary,
                      fontSize: widget.transaction.serviceId.toString() ==
                              0.toString()
                          ? 13
                          : screenSize.width < tabletBreakPoint
                              ? 14.5
                              : 24,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  widget.transaction.serviceId.toString() == 0.toString()
                      ? Text(
                          "${widget.transaction.accountNumber} (${widget.transaction.bankName})",
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontSize:
                                screenSize.width < tabletBreakPoint ? 11 : 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SizedBox(
                          height: screenSize.width < tabletBreakPoint
                              ? 5
                              : screenSize.width * 0.01,
                        ),
                  widget.transaction.serviceId.toString() == 0.toString()
                      ? SizedBox()
                      : Text(
                          "${DateFormat.jm().format(widget.transaction.createdAt)} ${humanDate(widget.transaction.createdAt)}"
                              .inTitleCase,
                          // "03:42 PM Today",
                          style: widget.transaction.serviceId.toString() ==
                                  0.toString()
                              ? trxDateTextStyle.copyWith(fontSize: 11)
                              : trxDateTextStyle,
                          textAlign: TextAlign.left,
                        ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₦${addCommas(widget.transaction.ngnAmount!)}",
                  style: widget.transaction.serviceId.toString() == 0.toString()
                      ? trxAmountTextStyle.copyWith(fontSize: 15.5)
                      : trxAmountTextStyle,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? widget.transaction.serviceId.toString() == 0.toString()
                          ? 2
                          : 5
                      : screenSize.width * 0.01,
                ),
                widget.transaction.serviceId.toString() == 0.toString()
                    ? Text(
                        "${DateFormat.jm().format(widget.transaction.createdAt)} ${humanDate(widget.transaction.createdAt)}"
                            .inTitleCase,
                        // "03:42 PM Today",
                        style: widget.transaction.serviceId.toString() ==
                                0.toString()
                            ? trxDateTextStyle.copyWith(fontSize: 11)
                            : trxDateTextStyle,
                        textAlign: TextAlign.left,
                      )
                    : getStatusWidget(trxStatus: widget.transaction.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget getStatusWidget({
  required int trxStatus,
}) {
  switch (trxStatus) {
    case 0:
      return Text(
        "Pending",
        style: GoogleFonts.poppins(
            fontSize: 12, color: kYellow, fontWeight: FontWeight.w500),
      );
    case 1:
      return Text(
        "Completed",
        style: GoogleFonts.poppins(
            fontSize: 12, color: kGreen, fontWeight: FontWeight.w500),
      );
    case 2:
      return Text(
        "Failed",
        style: GoogleFonts.poppins(
            fontSize: 12, color: kRed, fontWeight: FontWeight.w500),
      );
    case 3:
      return Text(
        "Cancelled",
        style: GoogleFonts.poppins(
            fontSize: 12, color: kPurple, fontWeight: FontWeight.w500),
      );
    default:
      return Text(
        "Pending",
        style: GoogleFonts.poppins(
            fontSize: 12, color: kPrimaryColor, fontWeight: FontWeight.w500),
      );
  }
}
