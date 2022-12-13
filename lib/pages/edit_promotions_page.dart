import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/home-data-info.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/form-field.dart';
import '../widgets/loading-modal.dart';
import '../widgets/primary-button.dart';
import '../widgets/secondary-button.dart';
import '../widgets/show-option-modal.dart';

io.File? newImage;

class EditPromotionsPage extends StatefulWidget {
  final Promotion promo;
  const EditPromotionsPage({Key? key, required this.promo}) : super(key: key);

  @override
  State<EditPromotionsPage> createState() => _EditPromotionsPageState();
}

class _EditPromotionsPageState extends State<EditPromotionsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.promo.promotionUrl;
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
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              newImage = io.File(result.files.single.path!);
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
                                  child: newImage == null
                                      ? CachedNetworkImage(
                                          imageUrl: widget.promo.bannerUrl,
                                          placeholder: (context, e) =>
                                              const SizedBox(
                                            height: 100,
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        )
                                      : Image.file(
                                          newImage!,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              readOnly: false,
                              keyboardType: getKeyboardType(
                                  inputType: AppInputType.number),
                              style: kFormTextStyle,
                              validator: textValidator,
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
                                  fontSize: screenSize.width < tabletBreakPoint
                                      ? 16
                                      : 18,
                                  fontWeight: FontWeight.w600,
                                  color: kInactive,
                                ),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(
                              height:
                                  screenSize.width < tabletBreakPoint ? 24 : 30,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        PrimaryButton(
                          title: Text(
                            "Update Promotion",
                            style: kPrimaryButtonTextStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool? proceed = await showOptionPopup(
                                  context: context,
                                  title: "Please Confirm",
                                  body:
                                      "Are you sure you want to update this banner ?",
                                  actionTitle: "I'm Sure",
                                  isDestructive: true);

                              if (proceed != null && proceed) {
                                showLoadingModal(
                                    context: context, title: "Updating Banner");
                                ProcessError error =
                                    await adminWorker.updateBanner(
                                        id: widget.promo.id,
                                        banner: newImage,
                                        url: _controller.text.trim().isEmpty
                                            ? null
                                            : _controller.text.trim(),
                                        context: context);
                                Navigator.pop(context);
                                if (error.any) {
                                  showErrorResponse(
                                      context: context, error: error);
                                } else {
                                  adminWorker.getHomeData(context: context);
                                  Navigator.pop(context);
                                  showInfoModal(
                                      context: context,
                                      title: "Success",
                                      content:
                                          "Banner has been updated successfully");
                                }
                              }
                            } else {
                              if (kDebugMode) {
                                print("good");
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SecondaryTextButton(
                          onPressed: () async {
                            bool? proceed = await showOptionPopup(
                                context: context,
                                title: "Please Confirm",
                                body:
                                    "Are you sure you want to update this banner ?",
                                actionTitle: "I'm Sure",
                                isDestructive: true);

                            if (proceed != null && proceed) {
                              showLoadingModal(
                                  context: context, title: "Updating Banner");
                              ProcessError error =
                                  await adminWorker.removeBanner(
                                      id: widget.promo.id, context: context);
                              Navigator.pop(context);
                              if (error.any) {
                                showErrorResponse(
                                    context: context, error: error);
                              } else {
                                adminWorker.getHomeData(context: context);
                                Navigator.pop(context);
                                showInfoModal(
                                    context: context,
                                    title: "Success",
                                    content:
                                        "Banner has been removed successfully");
                              }
                            }
                          },
                          title: "Remove Banner",
                          isActive: true,
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
    );
  }
}
