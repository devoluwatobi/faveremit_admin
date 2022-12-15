import 'package:faveremit_admin/config/styles.dart';
import 'package:faveremit_admin/extensions/time_string.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/dimensions.dart';
import '../main.dart';
import '../models/giftcard-country-model.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/danger_button.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/naira/naira.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-option-modal.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController _titleController = TextEditingController();
TextEditingController _amountController = TextEditingController();

class EditCategoryPage extends StatefulWidget {
  final ReceiptCategory category;
  const EditCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  @override
  void initState() {
    _titleController.text = widget.category.title;
    _amountController.text = widget.category.amount.toString();
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
            widget.category.title.inTitleCase,
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
                      Row(
                        children: [
                          Text(
                            "Rate in ",
                            style: GoogleFonts.poppins(
                                color: kTextSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize.width < tabletBreakPoint
                                    ? 12
                                    : 15),
                          ),
                          Naira(
                            size: 10,
                          ),
                        ],
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF6E41EE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: kDarkBG, width: 0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: widget.category.updatedAt ==
                                      widget.category.createdAt
                                  ? "Created At: "
                                  : "Last Updated: ",
                              style: TextStyle(color: kDarkBG, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: widget.category.updatedAt
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
                              text: widget.category.updatedAt ==
                                      widget.category.createdAt
                                  ? "Created By: "
                                  : "Updated By: ",
                              style: TextStyle(color: kDarkBG, fontSize: 12),
                              children: [
                                TextSpan(
                                  text: widget.category.updatedBy == 0 ||
                                          widget.category.updatedBy == null ||
                                          Provider.of<AppData>(context).users ==
                                              null
                                      ? "User ~ ${widget.category.updatedBy.toString()}"
                                          .inTitleCase
                                      : Provider.of<AppData>(context)
                                          .users!
                                          .firstWhere((element) =>
                                              element.id ==
                                              widget.category.updatedBy)
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
                  PrimaryTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool? _proceed = await showOptionPopup(
                              context: context,
                              title: "Please Confirm",
                              body:
                                  "Are you sure you want to update this giftcard category ?",
                              actionTitle: "I'm Sure",
                              isDestructive: true);

                          if (_proceed != null && _proceed) {
                            showLoadingModal(
                                context: context, title: "Updating Rate");
                            ProcessError _error =
                                await adminWorker.updateGiftcardCategory(
                                    context: context,
                                    id: widget.category.id,
                                    giftCardsId: widget.category.giftCardId,
                                    giftCardCountryId:
                                        widget.category.giftCardCountryId,
                                    rangeID: widget.category.id,
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
                                      "Giftcard Category updated successfully");
                            }
                          }
                        }
                      },
                      title: "Update Rate"),
                  const SizedBox(height: 16),
                  DangerTextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool? _proceed = await showOptionPopup(
                              context: context,
                              title: "Please Confirm",
                              body:
                                  "Are you sure you want to delete this giftcard range ?",
                              actionTitle: "I'm Sure",
                              isDestructive: true);

                          if (_proceed != null && _proceed) {
                            showLoadingModal(
                                context: context, title: "Deleting Category");
                            ProcessError _error =
                                await adminWorker.deleteCategory(
                              context: context,
                              id: widget.category.id,
                            );
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
                                      "Giftcard Category deleted successfully");
                            }
                          }
                        }
                      },
                      title: "Delete Rate")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
