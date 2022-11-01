import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/failed-reason-option-widget.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';

final _formKey = GlobalKey<FormState>();
TextEditingController _reasonController = TextEditingController();
int _reasonID = 0;

class FailedGiftcardTrxReason extends StatefulWidget {
  final int trxID;
  const FailedGiftcardTrxReason({
    Key? key,
    required this.trxID,
  }) : super(key: key);

  @override
  State<FailedGiftcardTrxReason> createState() =>
      _FailedGiftcardTrxReasonState();
}

class _FailedGiftcardTrxReasonState extends State<FailedGiftcardTrxReason> {
  @override
  void initState() {
    _reasonID = 0;
    _reasonController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cancel",
                style: GoogleFonts.poppins(color: kPrimaryColor),
              ),
            ],
          ),
        ),
        title: Text(
          "Failed Reason",
          style: GoogleFonts.poppins(color: kTextPrimary),
        ),
        backgroundColor: kFormBG,
        foregroundColor: kFormBG,
        elevation: 0,
      ),
      body: ListView(
        padding: kAppHorizontalPadding,
        children: [
          const SizedBox(
            height: 40,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  FailedReasonOption(
                    title: "Giftcard Used",
                    description:
                        "Velit eros, facilisi erat aenean aliquam, nulla odio at placerat. Sit consectetur amet ac volutpat volutpat.",
                    isActive: _reasonID == 0,
                    onPressed: () {
                      setState(() {
                        _reasonID = 0;
                      });
                    },
                  ),
                  FailedReasonOption(
                    title: "Image Not Clear",
                    description:
                        "Velit eros, facilisi erat aenean aliquam, nulla odio at placerat. Sit consectetur amet ac volutpat volutpat.",
                    isActive: _reasonID == 1,
                    onPressed: () {
                      setState(() {
                        _reasonID = 1;
                      });
                    },
                  ),
                  FailedReasonOption(
                    title: "Giftcard Invalid",
                    description:
                        "Velit eros, facilisi erat aenean aliquam, nulla odio at placerat. Sit consectetur amet ac volutpat volutpat.",
                    isActive: _reasonID == 2,
                    onPressed: () {
                      setState(() {
                        _reasonID = 2;
                      });
                    },
                  ),
                  FailedReasonOption(
                    title: "Other Reason",
                    description:
                        "Velit eros, facilisi erat aenean aliquam, nulla odio at placerat. Sit consectetur amet ac volutpat volutpat.",
                    isActive: _reasonID == 3,
                    onPressed: () {
                      setState(() {
                        _reasonID = 3;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _reasonID == 3
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Failed Reason",
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
                              decoration: appInputDecoration(
                                  inputType: AppInputType.textarea,
                                  hint:
                                      "Please enter reason why transaction failed "),
                              maxLines: 7,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.textarea),
                              style: kFormTextStyle,
                              controller: _reasonController,
                              validator: textValidator,
                            )
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 40,
                  ),
                  PrimaryTextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoadingModal(
                            context: context,
                            title: "Updating Withdrawal Status");
                        ProcessError error =
                            await adminWorker.rejectGiftcardTransaction(
                                context: context,
                                id: widget.trxID,
                                reason: _reasonID == 0
                                    ? "Giftcard Used"
                                    : _reasonID == 1
                                        ? "Giftcard Image not Clear"
                                        : _reasonID == 0
                                            ? "Giftcard Invalid"
                                            : _reasonController.text.trim());
                        Navigator.pop(context);
                        if (error.any) {
                          showErrorResponse(context: context, error: error);
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showInfoModal(
                              context: context,
                              title: "Success",
                              content:
                                  "Transaction Status has been updated sucessfully");
                        }
                      } else {
                        if (kDebugMode) print("bad form");
                      }
                    },
                    title: "Decline Transaction",
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
