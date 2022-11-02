import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-option-modal.dart';

final _formKey = GlobalKey<FormState>();
int _categoryID = 1;
TextEditingController _minController = TextEditingController();
TextEditingController _maxController = TextEditingController();
TextEditingController _ecodeController = TextEditingController();
TextEditingController _physicalController = TextEditingController();

class CreateRangeRatePage extends StatefulWidget {
  final String iso;
  final String cardTitle;
  final String cardCountry;
  final int gift_cards_id;
  final int gift_cards_country_id;

  const CreateRangeRatePage({
    Key? key,
    required this.iso,
    required this.cardTitle,
    required this.cardCountry,
    required this.gift_cards_id,
    required this.gift_cards_country_id,
  }) : super(key: key);

  @override
  State<CreateRangeRatePage> createState() => _CreateRangeRatePageState();
}

class _CreateRangeRatePageState extends State<CreateRangeRatePage> {
  _fetchEmailDetails() async {}

  @override
  void initState() {
    _minController.clear();
    _maxController.clear();
    _ecodeController.clear();
    _physicalController.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kFormBG,
        foregroundColor: kFormBG,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "cancel",
                style: GoogleFonts.poppins(color: kPrimaryColor),
              )
            ],
          ),
        ),
        title: Text(
          "Create Range",
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
            Column(
              children: [
                Padding(
                  padding: kAppHorizontalPadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: Provider.of<AppData>(context)
                          .giftCardList!
                          .firstWhere(
                              (element) => element.id == widget.gift_cards_id)
                          .image
                          .toString(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.cardCountry}",
                  style: GoogleFonts.poppins(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Min. Value",
                              style: GoogleFonts.poppins(
                                  color: kTextSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 15),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _minController,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.number),
                              style: kFormTextStyle,
                              validator: amountValidator(minimum: 1),
                              decoration: appInputDecoration(
                                  inputType: AppInputType.number,
                                  hint: "minimum card value"),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Max. Value",
                              style: GoogleFonts.poppins(
                                  color: kTextSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 12
                                      : 15),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _maxController,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.number),
                              style: kFormTextStyle,
                              validator: amountValidator(minimum: 1),
                              decoration: appInputDecoration(
                                  inputType: AppInputType.number,
                                  hint: "maximum card value"),
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            PrimaryTextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool? _proceed = await showOptionPopup(
                        context: context,
                        title: "Please Confirm",
                        body:
                            "Are you sure you want to create this giftcard range ?",
                        actionTitle: "I'm Sure",
                        isDestructive: true);

                    if (_proceed != null && _proceed) {
                      showLoadingModal(
                          context: context, title: "Creating Wallet");
                      ProcessError _error =
                          await adminWorker.createGiftcardRange(
                              min: int.parse(_minController.text.trim()),
                              max: int.parse(_maxController.text.trim()),
                              gift_cards_country_id:
                                  widget.gift_cards_country_id,
                              gift_cards_id: widget.gift_cards_id,
                              context: context);
                      Navigator.pop(context);
                      if (_error.any) {
                        showErrorResponse(context: context, error: _error);
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
                title: "Create Range"),
            const SizedBox(
              height: 20,
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
