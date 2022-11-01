import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';
import '../widgets/withdraw-terms.dart';

TextEditingController _amountController = TextEditingController();
String _bankAccount = "";

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _amountController.text = "0";
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
          "Withdraw",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: kGeneralWhite,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: kAppHorizontalPadding,
          children: [
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter the amount you want to withdraw",
                        style: kFormTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        autofocus: true,
                        autocorrect: true,
                        controller: _amountController,
                        keyboardType:
                            getKeyboardType(inputType: AppInputType.email),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize:
                              screenSize.width < tabletBreakPoint ? 44 : 50,
                          color: kTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: amountValidator(),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFFC9CCD3),
                                width: 0,
                                style: BorderStyle.none),
                          ),
                          hintMaxLines: 1,
                          fillColor: kFormBG,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: kRed,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: kRed,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFFC9CCD3),
                                width: 0,
                                style: BorderStyle.none),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  screenSize.width < tabletBreakPoint ? 17 : 24,
                              vertical: screenSize.width < tabletBreakPoint
                                  ? 17
                                  : 24),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFFC9CCD3),
                                width: 0,
                                style: BorderStyle.none),
                          ),
                          hintText: "E.G 500",
                          hintStyle: GoogleFonts.poppins(
                            fontSize:
                                screenSize.width < tabletBreakPoint ? 44 : 50,
                            color: kInactive.withOpacity(0.2),
                            fontWeight: FontWeight.w600,
                          ),
                          prefix: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₦",
                                style: GoogleFonts.poppins(
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 26
                                      : 32,
                                  color: kInactive,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          isCollapsed: false,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint ? 24 : 30,
                      )
                    ],
                  ),
                  // RichText(
                  //   text: TextSpan(
                  //       text: "Limit for this transaction is between ",
                  //       style: GoogleFonts.poppins(
                  //           fontSize: 12,
                  //           color: kTextPrimary.withOpacity(.8),
                  //           fontWeight: FontWeight.normal),
                  //       children: [
                  //         TextSpan(
                  //           text: "₦10,000",
                  //           style: GoogleFonts.poppins(
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //         TextSpan(
                  //           text: " and ",
                  //           style: GoogleFonts.poppins(
                  //               fontWeight: FontWeight.normal),
                  //         ),
                  //         TextSpan(
                  //           text: "₦5,000,000",
                  //           style: GoogleFonts.poppins(
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       ]),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Account",
                        style: kFormTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  screenSize.width < tabletBreakPoint ? 16 : 24,
                              vertical: screenSize.width < tabletBreakPoint
                                  ? 16
                                  : 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFFC9CCD3),
                                width: 0,
                                style: BorderStyle.solid),
                            color: kFormBG,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                    _bankAccount.isEmpty
                                        ? "select bank account"
                                        : _bankAccount.inTitleCase,
                                    style: GoogleFonts.mulish(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 18,
                                      fontWeight: FontWeight.w600,
                                      color: _bankAccount.isEmpty
                                          ? kInactive
                                          : kTextPrimary,
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                FlutterRemix.arrow_down_s_fill,
                                color: kTextGray,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint ? 24 : 30,
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFF7DDAC), width: 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Note",
                            style: GoogleFonts.poppins(
                                color: kYellow,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          color: Color(0xFFF7DDAC),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                            style: GoogleFonts.poppins(
                                color: kYellow,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  PrimaryTextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  contentPadding: EdgeInsets.all(10),
                                  content: WithdrawTerms(),
                                );
                              });
                        }
                      },
                      title: "Withdraw"),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsDateSegment extends StatelessWidget {
  final String date;
  const TransactionsDateSegment({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Text(
              date.inTitleCase,
              style: GoogleFonts.poppins(fontSize: 13, color: kTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
