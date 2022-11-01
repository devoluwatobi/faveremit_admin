import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';

TextEditingController _fullNameController = TextEditingController();
TextEditingController _amountController = TextEditingController();

Icon _passwordSuffix = Icon(
  CupertinoIcons.eye,
  size: 16,
  color: kPrimaryColor,
);

String _walletType = "";

class GiftCardSaleDetails extends StatefulWidget {
  const GiftCardSaleDetails({Key? key}) : super(key: key);

  @override
  _GiftCardSaleDetailsState createState() => _GiftCardSaleDetailsState();
}

class _GiftCardSaleDetailsState extends State<GiftCardSaleDetails> {
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
            "",
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
                            "Transaction Details",
                            style: kSubTitleStyle,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.026,
                          ),
                          Text(
                            "Provide the amount and wallet details of the transaction to be performed.",
                            style: kSubTextStyle,
                          ),
                          SizedBox(
                            height: screenSize.width < tabletBreakPoint
                                ? 40
                                : screenSize.width * 0.1,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wallet Type",
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
                                      screenSize.width < tabletBreakPoint
                                          ? 16
                                          : 24,
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
                                        _walletType.isEmpty
                                            ? "Choose wallet type"
                                            : _walletType.inTitleCase,
                                        style: GoogleFonts.mulish(
                                          fontSize: screenSize.width <
                                                  tabletBreakPoint
                                              ? 16
                                              : 18,
                                          fontWeight: FontWeight.w600,
                                          color: _walletType.isEmpty
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
                            height:
                                screenSize.width < tabletBreakPoint ? 24 : 30,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount in USD (\$)",
                            style: kFormTitleTextStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            keyboardType:
                                getKeyboardType(inputType: AppInputType.number),
                            style: kFormTextStyle,
                            controller: _amountController,
                            validator: amountValidator(),
                            decoration: appInputDecoration(
                                inputType: AppInputType.number,
                                hint: "enter amount in USD"),
                          ),
                          SizedBox(
                            height:
                                screenSize.width < tabletBreakPoint ? 24 : 30,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        children: [
                          Text(
                            "Amount you will receive",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: kTextGray),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "₦540,000.00",
                            style: GoogleFonts.poppins(
                                fontSize: 32,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      PrimaryButton(
                        title: Text(
                          "Continue",
                          style: kPrimaryButtonTextStyle,
                        ),
                        onPressed: () async {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => TradeBTCStep2()));

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
