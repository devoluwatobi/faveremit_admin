import 'package:faveremit_admin/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../main.dart';
import '../models/giftcard-country-model.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-option-modal.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController _titleController = TextEditingController();
TextEditingController _amountController = TextEditingController();

class CreateCategoryPage extends StatefulWidget {
  final GiftCardRange range;
  const CreateCategoryPage({Key? key, required this.range}) : super(key: key);

  @override
  _CreateCategoryPageState createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  @override
  void initState() {
    _titleController.clear();
    _amountController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kFormBG,
          foregroundColor: kFormBG,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FlutterRemix.arrow_down_s_fill,
              color: kTextPrimary,
            ),
          ),
          title: Text(
            "Create New Category",
            style: GoogleFonts.poppins(color: kTextPrimary),
          ),
        ),
        body: ListView(
          padding: kAppHorizontalPadding.copyWith(top: 20),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Receipt Category Title",
                        style: GoogleFonts.poppins(
                            color: kTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                screenSize.width < tabletBreakPoint ? 12 : 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _titleController,
                        keyboardType:
                            getKeyboardType(inputType: AppInputType.text),
                        style: kFormTextStyle,
                        validator: textValidator,
                        decoration: appInputDecoration(
                            inputType: AppInputType.text, hint: "title"),
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
                        "Rate in ₦",
                        style: GoogleFonts.poppins(
                            color: kTextSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                screenSize.width < tabletBreakPoint ? 12 : 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _amountController,
                        keyboardType:
                            getKeyboardType(inputType: AppInputType.number),
                        style: kFormTextStyle,
                        validator: amountValidator(minimum: 1),
                        decoration: appInputDecoration(
                            inputType: AppInputType.number,
                            hint: "rate amount in naira"),
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint ? 24 : 30,
                      )
                    ],
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
                                context: context, title: "Creating Category");
                            ProcessError _error =
                                await adminWorker.createGiftcardCategory(
                                    context: context,
                                    giftCardsId: widget.range.giftCardId,
                                    giftCardCountryId:
                                        widget.range.giftCardCountryId,
                                    rangeID: widget.range.id,
                                    amount: double.parse(
                                            _amountController.text.trim())
                                        .toInt(),
                                    title: _titleController.text.trim());
                            Navigator.pop(context);
                            if (_error.any) {
                              showErrorResponse(
                                  context: context, error: _error);
                            } else {
                              setState(() {
                                // widget.category = _error.data;
                              });
                              showInfoModal(
                                  context: context,
                                  title: "Success",
                                  content:
                                      "Giftcard Category created successfully");
                            }
                          }
                        }
                      },
                      title: "Create Category"),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
