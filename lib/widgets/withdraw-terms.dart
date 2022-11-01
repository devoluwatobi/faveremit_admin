import 'package:faveremit_admin/widgets/primary-button.dart';
import 'package:faveremit_admin/widgets/tertiary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/styles.dart';

class WithdrawTerms extends StatelessWidget {
  const WithdrawTerms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you Sure?",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: kTextPrimary,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Please read and agree to the these terms to proceed.",
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: kTextPrimary,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                      text: "",
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kTextPrimary,
                          fontWeight: FontWeight.normal),
                      children: [
                        // TextSpan(
                        //   text: "family and friends option",
                        //   style:
                        //       GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        // ),
                        // TextSpan(
                        //   text:
                        //       " in PayPal. \n \nThe duration of our payment can vary from minutes to hours but within 24hrs except in some cases when PayPal reviews payment for 24hrs. In such cases, there will be an extension in payment duration. \n \nWe put you our customer first, as such we would be available with you through the process.",
                        // ),
                        TextSpan(
                            text:
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                      ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                TertiaryTextButton(
                  title: "I Don’t Agree",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PrimaryButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    title: Text(
                      "I Agree",
                      style: kPrimaryButtonTextStyle,
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
