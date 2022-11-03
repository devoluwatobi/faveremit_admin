import 'dart:io' as io;

import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/models/crypto_wallet_address.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:faveremit_admin/widgets/secondary-button.dart';
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
import '../services-classes/functions.dart';
import '../widgets/form-field.dart';
import '../widgets/primary-button.dart';

bool _fetchedAddress = false;
Map? _btcAddress;
io.File? _paymentProofFile;
Widget? _paymentProof;
late CryptoWalletAddress _wallet;
String _selectedCrypto = "1";

TextEditingController _cryptoController = TextEditingController();

class EditWalletPage extends StatefulWidget {
  final CryptoWalletAddress wallet;

  const EditWalletPage({
    Key? key,
    required this.wallet,
  }) : super(key: key);

  @override
  _EditWalletPageState createState() => _EditWalletPageState();
}

class _EditWalletPageState extends State<EditWalletPage> {
  @override
  void initState() {
    _wallet = widget.wallet;
    _cryptoController.text = _wallet.address;
    _selectedCrypto = widget.wallet.crypto.id.toString();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
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
              "Wallet Details",
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
                                  data: _cryptoController.text,
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
                                  controller: _cryptoController,
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
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xFF6E41EE).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: kDarkBG, width: 0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: _wallet.createdAt ==
                                                _wallet.updatedAt
                                            ? "Created At: "
                                            : "Last Updated: ",
                                        style: TextStyle(
                                            color: kDarkBG, fontSize: 12),
                                        children: [
                                          TextSpan(
                                            text: _wallet.updatedAt
                                                .toDateTimeString()
                                                .inTitleCase,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          )
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: _wallet.createdAt ==
                                                _wallet.updatedAt
                                            ? "Created By: "
                                            : "Updated By: ",
                                        style: TextStyle(
                                            color: kDarkBG, fontSize: 12),
                                        children: [
                                          TextSpan(
                                            text: _wallet.updatedBy == 0
                                                ? "User ~ ${_wallet.updatedBy.toString()}"
                                                : Provider.of<AppData>(context)
                                                    .users!
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        int.parse(_wallet
                                                            .updatedBy
                                                            .toString()))
                                                    .name
                                                    .inTitleCase,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            PrimaryButton(
                              title: Text(
                                "Update Wallet",
                                style: kPrimaryButtonTextStyle,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool? proceed = await showOptionPopup(
                                      context: context,
                                      title: "Please Confirm",
                                      body:
                                          "Are you sure you want to update this bitcoin wallet address ?",
                                      actionTitle: "I'm Sure",
                                      isDestructive: true);

                                  if (proceed != null && proceed) {
                                    showLoadingModal(
                                        context: context,
                                        title: "Updating Wallet");
                                    ProcessError error =
                                        await adminWorker.updateCryptoWallet(
                                            id: _wallet.id,
                                            cryptoId:
                                                int.parse(_selectedCrypto),
                                            newAddress:
                                                _cryptoController.text.trim(),
                                            context: context);
                                    Navigator.pop(context);
                                    if (error.any) {
                                      showErrorResponse(
                                          context: context, error: error);
                                    } else {
                                      setState(() {
                                        _wallet = error.data;
                                      });
                                      showInfoModal(
                                          context: context,
                                          title: "Success",
                                          content:
                                              "Bitcoin wallet address updated successfully");
                                    }
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            SecondaryTextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  bool? _proceed = await showOptionPopup(
                                      context: context,
                                      title: "Please Confirm",
                                      body:
                                          "Are you sure you want to ${_wallet.status == 0 ? "a" : "dea"}ctivate this bitcoin wallet address ?",
                                      actionTitle: "I'm Sure",
                                      isDestructive: true);

                                  if (_proceed != null && _proceed) {
                                    showLoadingModal(
                                        context: context,
                                        title:
                                            "${_wallet.status == 0 ? "A" : "Dea"}ctivating Wallet");
                                    late ProcessError _error;
                                    if (_wallet.status == 0) {
                                      _error = await adminWorker
                                          .activateBitcoinWallet(
                                              id: _wallet.id, context: context);
                                    } else {
                                      _error = await adminWorker
                                          .deactivateBitcoinWallet(
                                              id: _wallet.id, context: context);
                                    }
                                    Navigator.pop(context);
                                    if (_error.any) {
                                      showErrorResponse(
                                          context: context, error: _error);
                                    } else {
                                      setState(() {
                                        _wallet = _error.data;
                                      });
                                      showInfoModal(
                                          context: context,
                                          title: "Success",
                                          content:
                                              "Bitcoin wallet address ${_wallet.status == 0 ? "a" : "dea"}ctivated successfully");
                                    }
                                  }
                                }
                              },
                              title:
                                  "${_wallet.status == 0 ? "A" : "Dea"}ctivate",
                              isActive: _wallet.status == 0,
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
      ),
    );
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
                    controller: _cryptoController,
                    decoration: InputDecoration(
                      hintMaxLines: 1,
                      suffix: GestureDetector(
                        onTap: () {
                          copyToClipboard(
                              copyText: _cryptoController.text,
                              context: context);
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
