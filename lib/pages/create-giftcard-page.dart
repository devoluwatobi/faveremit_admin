import 'dart:io' as io;

import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-option-modal.dart';

io.File? _giftcardImageFile;
Widget? _giftcardImage;

io.File? _giftcardLogoFile;
Widget? _giftcardLogo;

final _formKey = GlobalKey<FormState>();

TextEditingController _titleController = TextEditingController();

class CreateGiftcardPage extends StatefulWidget {
  const CreateGiftcardPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGiftcardPage> createState() => _CreateGiftcardPageState();
}

class _CreateGiftcardPageState extends State<CreateGiftcardPage> {
  @override
  void initState() {
    _giftcardImage = null;
    _giftcardLogo = null;
    _giftcardImageFile = null;
    _giftcardLogoFile = null;
    _titleController.clear();

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
          "Create Giftcard",
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
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Giftcard Title",
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
                            inputType: AppInputType.text,
                            hint: "giftcard name"),
                      ),
                      SizedBox(
                        height: screenSize.width < tabletBreakPoint ? 24 : 30,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);

                          if (result != null) {
                            _giftcardImageFile =
                                io.File(result.files.single.path!);
                            _giftcardImage = Column(
                              children: [
                                Text(
                                  "Tap to change Giftcard Image",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: kPrimaryColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.file(
                                  _giftcardImageFile!,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            );
                          } else {
                            // User canceled the picker
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFCBCFD5),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                            color: kGeneralWhite,
                          ),
                          child: _giftcardImage ??
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/giftcard_image.svg",
                                      height: 54,
                                      width: 54,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tap to Giftcard Image",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: kPrimaryColor),
                                    )
                                  ],
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);

                          if (result != null) {
                            _giftcardLogoFile =
                                io.File(result.files.single.path!);
                            _giftcardLogo = Column(
                              children: [
                                Text(
                                  "Tap to change Giftcard Logo",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: kPrimaryColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.file(
                                  _giftcardLogoFile!,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            );
                          } else {
                            // User canceled the picker
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFCBCFD5),
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                            color: kGeneralWhite,
                          ),
                          child: _giftcardLogo ??
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/giftcard_image.svg",
                                      height: 54,
                                      width: 54,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tap to Giftcard Logo",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: kPrimaryColor),
                                    )
                                  ],
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
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
                    if (_giftcardLogoFile != null &&
                        _giftcardImageFile != null) {
                      bool? _proceed = await showOptionPopup(
                          context: context,
                          title: "Please Confirm",
                          body:
                              "Are you sure you want to update this giftcard range ?",
                          actionTitle: "I'm Sure",
                          isDestructive: true);

                      if (_proceed != null && _proceed) {
                        showLoadingModal(
                            context: context, title: "Creating Giftcard");
                        ProcessError _error = await adminWorker.createGiftcard(
                            title: _titleController.text.trim(),
                            image: _giftcardImageFile!,
                            logo: _giftcardLogoFile!,
                            context: context);
                        Navigator.pop(context);
                        if (_error.any) {
                          showErrorResponse(context: context, error: _error);
                        } else {
                          Navigator.pop(context);
                          showInfoModal(
                              context: context,
                              title: "Success",
                              content: "Giftcard successfully");
                        }
                      }
                    } else {
                      showInfoModal(
                          context: context,
                          title: "Hey Chief",
                          content:
                              "You need to select giftcard image and logo to be able to create an new giftcard on Faveremit");
                    }
                  }
                },
                title: "Create Giftcard"),
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
