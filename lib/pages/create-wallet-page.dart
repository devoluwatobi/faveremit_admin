import 'dart:io' as io;

import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:faveremit_admin/widgets/show-option-modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../models/bitcoin-wallet-model.dart';
import '../services-classes/functions.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';

bool _fetchedAddress = false;
Map? _btcAddress;
io.File? _paymentProofFile;
Widget? _paymentProof;
late BtcWalletModel _wallet;
String _selectedCrypto = "1";

TextEditingController _btcController = TextEditingController();

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({
    Key? key,
  }) : super(key: key);

  @override
  _CreateWalletPageState createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  @override
  void initState() {
    _btcController.clear();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(builder: (context, appData, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: appSystemLightTheme,
        child: Scaffold(
          backgroundColor: kGeneralWhite,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                FlutterRemix.arrow_left_line,
                color: kTextPrimary,
              ),
            ),
            centerTitle: true,
            title: Text(
              "Create Crypto Wallet",
              style: GoogleFonts.poppins(color: kTextPrimary),
            ),
            backgroundColor: kBackground,
            elevation: 0,
            iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
            foregroundColor: kBackground,
          ),
          body: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
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
                            SizedBox(
                              height: screenSize.width < tabletBreakPoint
                                  ? 40
                                  : screenSize.width * 0.1,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // showCupertinoModalBottomSheet(
                                //     barrierColor:
                                //     Colors.black.withOpacity(0.8),
                                //     context: context,
                                //     builder: (context) => BarcodePage());
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                width: screenSize.width * 0.7,
                                height: screenSize.width * 0.7,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kPrimaryColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: QrImage(
                                  data: _btcController.text,
                                  version: QrVersions.auto,
                                  size: 110.0,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  readOnly: false,
                                  keyboardType: getKeyboardType(
                                      inputType: AppInputType.number),
                                  style: kFormTextStyle,
                                  validator: textValidator,
                                  controller: _btcController,
                                  onChanged: (x) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    hintMaxLines: 3,
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
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            screenSize.width < tabletBreakPoint
                                                ? 16
                                                : 24,
                                        vertical:
                                            screenSize.width < tabletBreakPoint
                                                ? 16
                                                : 24),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize:
                                          screenSize.width < tabletBreakPoint
                                              ? 16
                                              : 18,
                                      fontWeight: FontWeight.w600,
                                      color: kInactive,
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(
                                  height: screenSize.width < tabletBreakPoint
                                      ? 24
                                      : 30,
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Crypto Type",
                                  style: kFormTitleTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                appData.cryptos == null
                                    ? const SizedBox()
                                    : Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: const Color(0xFFC9CCD3),
                                              width: 0,
                                              style: BorderStyle.none),
                                          color: kFormBG,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InputDecorator(
                                                decoration: appInputDecoration(
                                                  inputType:
                                                      AppInputType.number,
                                                  hint: "select wallet type",
                                                ),
                                                isEmpty:
                                                    appData.cryptos == null ||
                                                        _selectedCrypto == '' ||
                                                        _selectedCrypto == '0',
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    icon: const Icon(
                                                        FlutterRemix
                                                            .arrow_down_s_line),
                                                    iconSize: 16,
                                                    elevation: 16,
                                                    value: _selectedCrypto,
                                                    isDense: true,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        _selectedCrypto =
                                                            newValue!;
                                                      });
                                                    },
                                                    items: appData.cryptos ==
                                                            null
                                                        ? [
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: "1",
                                                              child: Text(
                                                                "select",
                                                                style:
                                                                    kFormTextStyle,
                                                              ),
                                                            )
                                                          ]
                                                        : appData.cryptos!
                                                            .map((value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value.id
                                                                  .toString(),
                                                              child: Text(
                                                                value.name,
                                                                style:
                                                                    kFormTextStyle,
                                                              ),
                                                            );
                                                          }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                const SizedBox(
                                  height: 24,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            PrimaryButton(
                              title: Text(
                                "Create Wallet",
                                style: kPrimaryButtonTextStyle,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool? _proceed = await showOptionPopup(
                                      context: context,
                                      title: "Please Confirm",
                                      body:
                                          "Are you sure you want to create this bitcoin wallet address ?",
                                      actionTitle: "I'm Sure",
                                      isDestructive: false);

                                  if (_proceed != null && _proceed) {
                                    showLoadingModal(
                                        context: context,
                                        title: "Creating Wallet");
                                    ProcessError _error =
                                        await adminWorker.createCryptoWallet(
                                            address: _btcController.text.trim(),
                                            cryptoId:
                                                int.parse(_selectedCrypto),
                                            context: context);
                                    Navigator.pop(context);
                                    if (_error.any) {
                                      showErrorResponse(
                                          context: context, error: _error);
                                    } else {
                                      Navigator.pop(context);
                                      showInfoModal(
                                          context: context,
                                          title: "Success",
                                          content:
                                              "Bitcoin wallet address created successfully");
                                    }
                                  }
                                }
                              },
                            ),
                          ],
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
    });
  }

  @override
  void dispose() {
    _btcAddress = null;
    _paymentProof = null;
    _paymentProofFile = null;
    super.dispose();
  }
}

//Page Shimmer
class _PageShimmer extends StatelessWidget {
  const _PageShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // showCupertinoModalBottomSheet(
              //     barrierColor: Colors.black.withOpacity(0.8),
              //     context: context,
              //     builder: (context) => BarcodePage());
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              width: screenSize.width * 0.7,
              height: screenSize.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(
                  color: kPrimaryColor,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: QrImage(
                data:
                    "ewrdftgvhbjnklojknbvfyrdtyfguiewrdftgvhbjnklojknbvfyrdtyfgui",
                version: QrVersions.auto,
                size: 110.0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: getKeyboardType(inputType: AppInputType.number),
                style: kFormTextStyle,
                initialValue: "ewrdftgvhbjnklojknbvfyrdtyfgui",
                validator: amountValidator(),
                decoration: InputDecoration(
                  hintMaxLines: 1,
                  suffix: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "copy",
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          FlutterRemix.file_copy_line,
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                  ),
                  fillColor: kFormBG,
                  filled: true,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: kRed, width: 1, style: BorderStyle.solid),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: kRed, width: 1, style: BorderStyle.solid),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: screenSize.width < tabletBreakPoint ? 16 : 24,
                      vertical: screenSize.width < tabletBreakPoint ? 16 : 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: screenSize.width < tabletBreakPoint ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: kInactive,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bitcoin Amount",
                    style: kFormTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    readOnly: true,
                    keyboardType:
                        getKeyboardType(inputType: AppInputType.number),
                    style: kFormTextStyle,
                    controller: _btcController,
                    decoration: InputDecoration(
                      hintMaxLines: 1,
                      suffix: GestureDetector(
                        onTap: () {
                          copyToClipboard(
                              copyText: _btcController.text, context: context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "copy",
                              style: GoogleFonts.poppins(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              FlutterRemix.file_copy_line,
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      ),
                      fillColor: kFormBG,
                      filled: true,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: kRed, width: 1, style: BorderStyle.solid),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: kRed, width: 1, style: BorderStyle.solid),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              screenSize.width < tabletBreakPoint ? 16 : 24,
                          vertical:
                              screenSize.width < tabletBreakPoint ? 16 : 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: screenSize.width < tabletBreakPoint ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: kInactive,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint ? 24 : 30,
                  )
                ],
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint ? 24 : 30,
              )
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color(0xFFCBCFD5), width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
              color: kGeneralWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/btc_proof.svg",
                  height: 54,
                  width: 54,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Tap to upload payment proof",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kPrimaryColor),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Please ensure that you copied the right wallet address before sending the bitcoin",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: kTextGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24,
          ),
          const SizedBox(
            height: 60,
          ),
          PrimaryButton(
            title: Text(
              "Continue",
              style: kPrimaryButtonTextStyle,
            ),
            onPressed: () async {},
          ),
        ],
      ),
    );
  }
}
