import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/functions.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';

class AirtimePage extends StatefulWidget {
  const AirtimePage({Key? key}) : super(key: key);

  @override
  _AirtimePageState createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: kTextPrimary),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        title: Text(
          "Buy Airtime",
          style: GoogleFonts.poppins(color: kTextPrimary),
        ),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 20
                : screenSize.width * 0.1,
          ),
          Padding(
            padding: kAppHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: kFormTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType:
                          getKeyboardType(inputType: AppInputType.number),
                      style: kFormTextStyle,
                      validator: numberValidator,
                      decoration: appInputDecoration(
                          inputType: AppInputType.number, hint: "amount"),
                    ),
                    SizedBox(
                      height: screenSize.width < tabletBreakPoint ? 24 : 30,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Network",
                      style: kFormTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType:
                          getKeyboardType(inputType: AppInputType.text),
                      style: kFormTextStyle,
                      validator: numberValidator,
                      decoration: appInputDecoration(
                          inputType: AppInputType.text, hint: "bank name"),
                    ),
                    SizedBox(
                      height: screenSize.width < tabletBreakPoint ? 24 : 30,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: kFormTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType:
                          getKeyboardType(inputType: AppInputType.phone),
                      style: kFormTextStyle,
                      validator: phoneValidator,
                      decoration: appInputDecoration(
                          inputType: AppInputType.number,
                          hint: "081 XXX XXXX XXX"),
                    ),
                    SizedBox(
                      height: screenSize.width < tabletBreakPoint ? 24 : 30,
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
                ),
                PrimaryButton(
                  title: Text(
                    "Continue",
                    style: kPrimaryButtonTextStyle,
                  ),
                  onPressed: () {},
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 60
                      : screenSize.width * 0.15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FundsFromBankPage extends StatefulWidget {
  const FundsFromBankPage({Key? key}) : super(key: key);

  @override
  _FundsFromBankPageState createState() => _FundsFromBankPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class _FundsFromBankPageState extends State<FundsFromBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTextPrimary),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: screenSize.width < tabletBreakPoint
                ? 20
                : screenSize.width * 0.1,
          ),
          Padding(
            padding: kAppHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "By Bank Transfer",
                  style: kSubTitleStyle,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 10
                      : screenSize.width * 0.026,
                ),
                Text(
                  "Fund your FlurryPay wallet by sending money to your designated account number.",
                  style: kSubTextStyle,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 40
                      : screenSize.width * 0.1,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3A87FD).withOpacity(.4),
                            offset: Offset(0, 20),
                            spreadRadius: -10,
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height:
                                screenSize.width < tabletBreakPoint ? 130 : 190,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment
                                    .bottomCenter, // 10% of the width, so there are ten blinds.
                                colors: <Color>[
                                  Color(0xFF0985FA),
                                  Color(0xFF094AFA),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -30,
                            bottom: -30,
                            child: Opacity(
                                opacity: 1,
                                child: Image.asset(
                                  "assets/svg/flurry-vector-2.png",
                                  width: screenSize.width * 0.6,
                                )

                                // SvgPicture.asset(
                                //   "assets/svg/flurry-vector-2.png",
                                //   color: kGeneralWhite,
                                //   width: screenSize.width * 0.6,
                                // ),
                                ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Account Details",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: kGeneralWhite,
                                            fontSize: screenSize.width <
                                                    tabletBreakPoint
                                                ? 13
                                                : 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(
                                      "assets/logos/logo-primary.svg",
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 14
                                              : 20,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.width < tabletBreakPoint
                                      ? 10
                                      : 20,
                                ),
                                Text(
                                  "0123456789",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: kGeneralWhite,
                                    fontSize:
                                        screenSize.width < tabletBreakPoint
                                            ? 24
                                            : 32,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "GUARANTY TRUST BANK",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: kGeneralWhite,
                                        fontSize:
                                            screenSize.width < tabletBreakPoint
                                                ? 13
                                                : 28,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        copyToClipboard(
                                            copyText: "0123456789",
                                            context: context);
                                      },
                                      child: Icon(
                                        FlutterRemix.file_copy_line,
                                        color: kGeneralWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BTCTransactionDetails extends StatefulWidget {
  const BTCTransactionDetails({Key? key}) : super(key: key);

  @override
  _BTCTransactionDetailsState createState() => _BTCTransactionDetailsState();
}

final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey();

class _BTCTransactionDetailsState extends State<BTCTransactionDetails> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        key: _scaffoldKey2,
        backgroundColor: kGeneralWhite,
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                FlutterRemix.close_circle_fill,
                size: screenSize.width < tabletBreakPoint ? 24 : 32,
                color: kTextGray,
              ),
            ),
          ),
          middle: Text(
            "",
            style: GoogleFonts.poppins(),
          ),
        ),
        // backgroundColor: kGeneralWhite,

        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: screenSize.width < tabletBreakPoint
                  ? 20
                  : screenSize.width * 0.1,
            ),
            Padding(
              padding: kAppHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review & Confirmation",
                    style: kSubTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 10
                        : screenSize.width * 0.026,
                  ),
                  Text(
                    "Transaction is pending while we confirm your bitcoin transfer.",
                    style: kSubTextStyle,
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 40
                        : screenSize.width * 0.1,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            screenSize.width < tabletBreakPoint ? 28 : 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              screenSize.width < tabletBreakPoint ? 24 : 36),
                          color: kGeneralWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF606470).withOpacity(.1),
                              offset: Offset(0, 5),
                              spreadRadius: 0,
                              blurRadius: 20,
                            )
                          ],
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "Amount Sent",
                              style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 14
                                      : 20,
                                  color: kTextGray,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 5 : 10,
                            ),
                            Text(
                              "\$500",
                              style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 32
                                      : 48,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 36,
                            ),
                            Divider(
                              color: Color(0xFFEEEEEE),
                              thickness:
                                  screenSize.width < tabletBreakPoint ? 1 : 2,
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 12 : 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "BTC Value",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 24,
                                      color: kTextGray,
                                    ),
                                  )),
                                  Text(
                                    "0.000345",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 18
                                              : 30,
                                      color: kTextPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Rate",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 24,
                                      color: kTextGray,
                                    ),
                                  )),
                                  Text(
                                    "570/\$",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 18
                                              : 30,
                                      color: kTextPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Value",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 24,
                                      color: kTextGray,
                                    ),
                                  )),
                                  Text(
                                    "₦540,000.00",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 18
                                              : 30,
                                      color: kTextPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Status",
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 24,
                                      color: kTextGray,
                                    ),
                                  )),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: kYellow,
                                        borderRadius: BorderRadius.circular(
                                            screenSize.width < tabletBreakPoint
                                                ? 6
                                                : 10)),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          screenSize.width < tabletBreakPoint
                                              ? 10
                                              : 16,
                                      vertical:
                                          screenSize.width < tabletBreakPoint
                                              ? 6
                                              : 10,
                                    ),
                                    child: Text(
                                      "Awaiting Confirmation",
                                      style: GoogleFonts.poppins(
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 10
                                              : 36,
                                          color: kGeneralWhite,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 60
                        : screenSize.width * 0.15,
                  ),
                  PrimaryButton(
                    title: Text(
                      "Continue",
                      style: kPrimaryButtonTextStyle,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 60
                        : screenSize.width * 0.15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
