import 'package:flutter/cupertino.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';

class WithdrawalItem extends StatelessWidget {
  const WithdrawalItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ? 10
              : screenSize.width * 0.02),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kRed.withOpacity(0.2),
            ),
            child: Icon(
              FlutterRemix.arrow_right_up_fill,
              color: kRed,
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
                  "Withdrawal",
                  style: trxTitleTextStyle,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
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
                height: screenSize.width < tabletBreakPoint
                    ? 5
                    : screenSize.width * 0.01,
              ),
              Text(
                "Completed",
                style: GoogleFonts.poppins(
                    color: kGreen,
                    fontSize: screenSize.width < tabletBreakPoint ? 14 : 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
