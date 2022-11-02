import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/pages/receipt_categories_list.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../models/giftcard-country-model.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/secondary-button.dart';
import '../widgets/show-option-modal.dart';

final _formKey = GlobalKey<FormState>();
int _categoryID = 1;
TextEditingController _minController = TextEditingController();
TextEditingController _maxController = TextEditingController();
TextEditingController _ecodeController = TextEditingController();
TextEditingController _physicalController = TextEditingController();
late GiftCardRange _range;

class RangeRateDetailsPage extends StatefulWidget {
  final GiftCardRange range;
  final String iso;
  final String cardTitle;
  final String cardCountry;
  const RangeRateDetailsPage({
    Key? key,
    required this.range,
    required this.iso,
    required this.cardTitle,
    required this.cardCountry,
  }) : super(key: key);

  @override
  State<RangeRateDetailsPage> createState() => _RangeRateDetailsPageState();
}

class _RangeRateDetailsPageState extends State<RangeRateDetailsPage> {
  _fetchEmailDetails() async {}

  @override
  void initState() {
    _range = widget.range;
    _minController.text = _range.min.toString();
    _maxController.text = _range.max.toString();

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
          "Range Details",
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
                              (element) => element.id == _range.giftCardId)
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
                  const SizedBox(
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
                                  hint: "minimum card value"),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xFF6E41EE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: kPrimaryColor, width: 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: _range.updatedAt == _range.createdAt
                            ? "Created At: "
                            : "Last Updated: ",
                        style: TextStyle(color: kPrimaryColor, fontSize: 12),
                        children: [
                          TextSpan(
                            text: "${_range.updatedAt.toDateTimeString()}"
                                .inTitleCase,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: _range.updatedAt == _range.createdAt
                            ? "Created By: "
                            : "Updated By: ",
                        style: TextStyle(color: kPrimaryColor, fontSize: 12),
                        children: [
                          TextSpan(
                            text: _range.updatedBy == 0 ||
                                    _range.updatedBy == null ||
                                    Provider.of<AppData>(context).users == null
                                ? "User ~ ${_range.updatedBy.toString()}"
                                    .inTitleCase
                                : Provider.of<AppData>(context)
                                    .users!
                                    .firstWhere((element) =>
                                        element.id == _range.updatedBy)
                                    .name
                                    .inTitleCase,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            PrimaryTextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool? _proceed = await showOptionPopup(
                        context: context,
                        title: "Please Confirm",
                        body:
                            "Are you sure you want to update this giftcard range ?",
                        actionTitle: "I'm Sure",
                        isDestructive: true);

                    if (_proceed != null && _proceed) {
                      showLoadingModal(
                          context: context, title: "Updating Wallet");
                      ProcessError _error =
                          await adminWorker.updateGiftcardRange(
                              id: _range.id,
                              min: int.parse(_minController.text.trim()),
                              max: int.parse(_maxController.text.trim()),
                              ecode_rate:
                                  int.parse(_ecodeController.text.trim()),
                              physical_rate:
                                  int.parse(_physicalController.text.trim()),
                              gift_cards_country_id: _range.giftCardCountryId,
                              gift_cards_id: _range.giftCardId,
                              context: context);
                      Navigator.pop(context);
                      if (_error.any) {
                        showErrorResponse(context: context, error: _error);
                      } else {
                        setState(() {
                          _range = _error.data;
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
                title: "Update Rate"),
            const SizedBox(height: 16),
            SecondaryTextButton(
                onPressed: () async {
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => CategoriesListPage(
                          categories: _range.receiptCategories));
                },
                title: "Receipt Categories"),
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
