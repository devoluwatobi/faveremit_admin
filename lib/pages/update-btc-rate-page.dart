import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/models/home-data-info.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';
import '../widgets/withdraw-terms.dart';

TextEditingController _amountController = TextEditingController();

class BitcoinRatePage extends StatefulWidget {
  final CryptoRate rate;
  const BitcoinRatePage({Key? key, required this.rate}) : super(key: key);

  @override
  _BitcoinRatePageState createState() => _BitcoinRatePageState();
}

class _BitcoinRatePageState extends State<BitcoinRatePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _amountController.text = widget.rate.value.toString();
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
          "${widget.rate.crypto.name} Rate",
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
                        "Enter the new ${widget.rate.crypto.name.toLowerCase()} rate",
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
                        validator: amountValidator(
                          minimum: 1,
                        ),
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
                          hintText: "600",
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
                  const SizedBox(
                    height: 60,
                  ),
                  PrimaryTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool? _proceed = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  contentPadding: const EdgeInsets.all(10),
                                  content: const WithdrawTerms(),
                                );
                              });
                          if (_proceed != null && _proceed) {
                            if (_formKey.currentState!.validate()) {
                              showLoadingModal(
                                  context: context, title: "updating Rate");
                              ProcessError _error =
                                  await adminWorker.updateCryptoRate(
                                      value: double.parse(
                                              _amountController.text.trim())
                                          .toInt(),
                                      context: context,
                                      cryptoId: widget.rate.cryptoId);
                              Navigator.pop(context);
                              if (_error.any) {
                                showErrorResponse(
                                    context: context, error: _error);
                              } else {
                                adminWorker.getHomeData(context: context);
                                showInfoModal(
                                    context: context,
                                    title: "Success",
                                    content:
                                        "The ${widget.rate.crypto.name.inTitleCase} rate has been updated successfully");
                              }
                            }
                          }
                        }
                      },
                      title: "Update Rate").showOrHide(Provider.of<UserData>(context, listen: false).userModel!.user.role != null && (Provider.of<UserData>(context, listen: false).userModel!.user.role! == 1)),
                  const SizedBox(
                    height: 60,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.rate.updatedBy == 0
                                    ? "Updated By: User - ${widget.rate.updatedBy}"
                                    : "Updated By: ${Provider.of<AppData>(context).users!.firstWhere((element) => element.id == widget.rate.updatedBy).name.inTitleCase}",
                                style: GoogleFonts.poppins(
                                    color: kYellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Updated At: ${widget.rate.updatedAt.toDateTimeString()}"
                                    .inTitleCase,
                                style: GoogleFonts.poppins(
                                    color: kYellow,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
