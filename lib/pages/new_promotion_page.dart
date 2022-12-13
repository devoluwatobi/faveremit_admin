import 'dart:io' as io;

import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/show-option-modal.dart';

io.File? _image;
bool _toggle = true;

class NewPromotionPage extends StatefulWidget {
  const NewPromotionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewPromotionPage> createState() => _NewPromotionPageState();
}

class _NewPromotionPageState extends State<NewPromotionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _toggle = true;
    _controller.clear();
    _image = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Promotions Details",
          style: GoogleFonts.poppins(color: kTextPrimary),
        ),
        backgroundColor: kBackground,
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
        foregroundColor: kBackground,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width < tabletBreakPoint
                      ? 20
                      : screenSize.width * 0.04),
              child: Column(
                children: [
                  Column(
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.image);

                                if (result != null) {
                                  _image = io.File(result.files.single.path!);
                                } else {
                                  // User canceled the picker
                                }
                                setState(() {});
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Tap to Update Promotion Image",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kPrimaryColor,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _image == null
                                          ? SizedBox(
                                              height: 100,
                                              width: double.infinity,
                                              child: Center(
                                                child: LottieBuilder.asset(
                                                  "assets/lottie/upload.json",
                                                  frameRate: FrameRate(60),
                                                ),
                                              ),
                                            )
                                          : Image.file(
                                              _image!,
                                              // frameBuilder: (context, x, y, z) =>
                                              //     const SizedBox(
                                              //   height: 100,
                                              //   child: CupertinoActivityIndicator(),
                                              // ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CupertinoSwitch(
                                          activeColor: kPrimaryColor,
                                          value: _toggle,
                                          onChanged: (x) {
                                            setState(() {
                                              _toggle = x;
                                            });
                                          }),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: "Add Promotion url ?",
                                            style: kFormTitleTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenSize.width < tabletBreakPoint
                                        ? 24
                                        : 30,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  readOnly: false,
                                  keyboardType: getKeyboardType(
                                      inputType: AppInputType.text),
                                  style: kFormTextStyle,
                                  validator: urlValidator,
                                  controller: _controller,
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
                            ).showOrHide(_toggle),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  PrimaryButton(
                    title: Text(
                      "Upload Promotion",
                      style: kPrimaryButtonTextStyle,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool? proceed = await showOptionPopup(
                            context: context,
                            title: "Please Confirm",
                            body:
                                "Are you sure you want to upload this banner ?",
                            actionTitle: "I'm Sure",
                            isDestructive: true);

                        if (proceed != null && proceed) {
                          showLoadingModal(
                              context: context, title: "Uploading Banner");
                          ProcessError error = await adminWorker.uploadBanner(
                              banner: _image!,
                              url: _controller.text.trim(),
                              context: context);
                          Navigator.pop(context);
                          if (error.any) {
                            showErrorResponse(context: context, error: error);
                          } else {
                            adminWorker.getHomeData(context: context);
                            Navigator.pop(context);
                            showInfoModal(
                                context: context,
                                title: "Success",
                                content:
                                    "Banner has been uploaded successfully");
                          }
                        }
                      } else {
                        print("good");
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
