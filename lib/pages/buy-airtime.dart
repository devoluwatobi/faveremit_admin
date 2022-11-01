import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:faveremit_admin/widgets/primary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/form-field.dart';

TextEditingController _amountController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
String _bankAccount = "";
late PhoneNumber? _phoneNumber;
late String _number;

class BuyAirtimePage extends StatefulWidget {
  const BuyAirtimePage({Key? key}) : super(key: key);

  @override
  _BuyAirtimePageState createState() => _BuyAirtimePageState();
}

class _BuyAirtimePageState extends State<BuyAirtimePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _amountController.clear();
    _phoneController.text = Provider.of<UserData>(context, listen: false)
        .userModel!
        .user
        .phone
        .substring(4);
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
          "Buy Airtime",
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
                children: [
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
                        controller: _amountController,
                        keyboardType:
                            getKeyboardType(inputType: AppInputType.number),
                        style: kFormTextStyle,
                        validator: amountValidator(),
                        decoration: appInputDecoration(
                          inputType: AppInputType.text,
                          hint: "eg 1000",
                        ),
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
                            color: kFormBG,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _bankAccount ?? "select sector",
                                style: GoogleFonts.poppins(
                                    fontSize:
                                        screenSize.width < tabletBreakPoint
                                            ? 16
                                            : 18,
                                    fontWeight: FontWeight.w600,
                                    color: _bankAccount == null
                                        ? kInactive
                                        : kTextPrimary),
                              ),
                              Icon(
                                FlutterRemix.arrow_down_s_line,
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
                      InternationalPhoneNumberInput(
                        textStyle: kFormTextStyle,
                        // initialValue: _phoneNumber,
                        inputDecoration: appInputDecoration(
                            inputType: AppInputType.phone, hint: "8X XXX XXXX"),
                        onInputChanged: (PhoneNumber number) {
                          // print(number.phoneNumber);
                          _phoneNumber = number;
                          print(_phoneNumber!.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        countries: ["NG"],
                        selectorConfig: SelectorConfig(
                            setSelectorButtonAsPrefixIcon: true,
                            leadingPadding: 16,
                            useEmoji: false,
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            trailingSpace: true),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: kFormTextStyle,
                        textFieldController: _phoneController,
                        formatInput: false,
                        keyboardType:
                            getKeyboardType(inputType: AppInputType.phone),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
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
                  PrimaryTextButton(onPressed: () {}, title: "Continue")
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
