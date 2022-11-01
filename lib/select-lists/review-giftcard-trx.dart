import 'package:faveremit_admin/select-lists/failed-giftcard-trx-reason.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/color-button.dart';
import '../widgets/loading-modal.dart';
import '../widgets/review-trx-option-widget.dart';
import '../widgets/tertiary-button.dart';

class ReviewGiftcardTrxOptionsList extends StatelessWidget {
  final int trxID;
  final bool canApprove;
  const ReviewGiftcardTrxOptionsList({
    Key? key,
    required this.trxID,
    required this.canApprove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: kGeneralWhite,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FlutterRemix.close_fill,
                    color: kTextGray,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review Giftcard Transaction",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: kTextPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ReviewTrxOption(
                    title: "Approve",
                    description:
                        "This is to update the clients dashboard that their transaction is completed and successful.",
                    color: kGreen,
                    id: 4,
                    onPressed: () {
                      if (canApprove) {
                        _acceptGiftcardTransaction(
                          context: context,
                          trxID: trxID,
                        );
                      } else {
                        showInfoModal(
                            context: context,
                            title: "Oops!",
                            content:
                                "Can't approve withdrawal because some bank account information may be missing");
                      }
                    },
                  ),
                  ReviewTrxOption(
                    title: "Fail Transaction",
                    description:
                        "This is to update the clients dashboard that the transaction was a Failed one, with a specific reason..",
                    color: kRed,
                    id: 3,
                    onPressed: () async {
                      await showCupertinoModalBottomSheet(
                        context: context,
                        expand: false,
                        barrierColor: const Color(0xFF000000).withOpacity(0.6),
                        builder: (context) {
                          return FailedGiftcardTrxReason(trxID: trxID);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void _acceptGiftcardTransaction({
  required BuildContext context,
  required int trxID,
}) async {
  bool? _proceed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(10),
          content: Container(
            color: kGeneralWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        FlutterRemix.close_fill,
                        color: kTextGray,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Please Confirm",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: kTextPrimary,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: kTextPrimary,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ColorTextButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                        },
                        title: "Approve Transaction",
                        color: kGreen,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TertiaryTextButton2(
                        title: "cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
  if (_proceed != null && _proceed) {
    showLoadingModal(context: context, title: "Updating Transaction Status");
    ProcessError _error =
        await adminWorker.acceptGiftcardTransaction(context: context, id: trxID);
    Navigator.pop(context);
    if (_error.any) {
      Navigator.pop(context);
      await showErrorResponse(context: context, error: _error);
    } else {
      Navigator.pop(context);
      await showInfoModal(
          context: context,
          title: "Success",
          content: "The Transaction status has been updated successfully");
    }
  } else {
    Navigator.pop(context);
  }
}
