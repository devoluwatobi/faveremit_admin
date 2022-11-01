import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/primary-button.dart';

TextEditingController _fullNameController = TextEditingController();
TextEditingController _amountController = TextEditingController();

Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);

String _walletType = "";

class TradeBTCStep3 extends StatefulWidget {
  final double usdAmount;
  const TradeBTCStep3({Key? key, required this.usdAmount}) : super(key: key);

  @override
  _TradeBTCStep3State createState() => _TradeBTCStep3State();
}

class _TradeBTCStep3State extends State<TradeBTCStep3> {
  @override
  void initState() {
    _walletType = "";
    _fullNameController.clear();
    _amountController.clear();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appSystemLightTheme,
      child: Scaffold(
        backgroundColor: kGeneralWhite,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            "Trade BTC",
            style: GoogleFonts.poppins(color: kTextPrimary),
          ),
          backgroundColor: kGeneralWhite,
          elevation: 0,
          iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
          foregroundColor: kGeneralWhite,
        ),
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: kAppHorizontalPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                          ),
                        ),
                        height: 6,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Container(
                        color: kPrimaryColor,
                        height: 6,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(3),
                            bottomRight: Radius.circular(3),
                          ),
                        ),
                        height: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width < tabletBreakPoint
                        ? 20
                        : screenSize.width * 0.04),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
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
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kGeneralWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF606470).withOpacity(.1),
                              blurRadius: 20,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 30),
                        child: Column(
                          children: [
                            Text(
                              "Amount Sent",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: kTextGray),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "\$${addCommas(widget.usdAmount.toStringAsFixed(2))}",
                              style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Color(0xFFEEEEEE),
                              thickness: 1,
                              height: 45,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "BTC Value",
                                    style: GoogleFonts.poppins(
                                      color: kTextGray,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${(widget.usdAmount / Provider.of<AppData>(context, listen: false).btcTradeData!.usdValue).toPrecision(10)}",
                                  style: GoogleFonts.poppins(
                                      color: kTextPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Rate",
                                    style: GoogleFonts.poppins(
                                      color: kTextGray,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "${Provider.of<AppData>(context, listen: false).btcTradeData!.usdRate}/\$",
                                  style: GoogleFonts.poppins(
                                      color: kTextPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Value",
                                    style: GoogleFonts.poppins(
                                      color: kTextGray,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "₦${addCommas((widget.usdAmount * Provider.of<AppData>(context, listen: false).btcTradeData!.usdRate).toStringAsFixed(2))}",
                                  style: GoogleFonts.poppins(
                                      color: kTextPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Status",
                                    style: GoogleFonts.poppins(
                                      color: kTextGray,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: kYellow,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    "Awaiting Confirmation",
                                    style: GoogleFonts.poppins(
                                        color: kGeneralWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      PrimaryButton(
                        title: Text(
                          "Complete",
                          style: kPrimaryButtonTextStyle,
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(context, "awaitEmail");
                          // if (_bankName.isNotEmpty) {
                          //   if (_formKey.currentState!.validate()) {}
                          // } else {
                          //   showInfoModal(
                          //       context: context,
                          //       title: "Hey!",
                          //       content:
                          //           "you need to select your bank name to complete your registration");
                          // }
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return kInactive;
  }
  return kPrimaryColor;
}

bool _isChecked = false;
