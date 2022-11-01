import 'dart:async';

import 'package:faveremit_admin/select-lists/dx-country-list.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:faveremit_admin/services-classes/info-modal.dart';
import 'package:faveremit_admin/widgets/loading-modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/gift-card-mode.dart';
import '../models/single-giftcard-model.dart';
import '../services-classes/app-worker.dart';
import '../widgets/app-fab.dart';
import '../widgets/giftcard-country-widget.dart';
import '../widgets/show-option-modal.dart';
import '../widgets/show-snackbar.dart';
import 'edit-giftcard-page.dart';

GiftCardInfo? _giftCardInfo;
late Timer _periodicSync;

class SingleGiftCardPage extends StatefulWidget {
  final GiftCardModel giftCardModel;
  const SingleGiftCardPage({Key? key, required this.giftCardModel})
      : super(key: key);

  @override
  _SingleGiftCardPageState createState() => _SingleGiftCardPageState();
}

TextEditingController _searchController = TextEditingController();

class _SingleGiftCardPageState extends State<SingleGiftCardPage> {
  _fetchGiftCards() async {
    ProcessError error = await adminWorker.getSingleGiftCard(
        context: context, id: widget.giftCardModel.id);
    if (error.any) {
      dynamic rez = await showSingleOptionPopup(
          context: context,
          title: "Oops!",
          body:
              "Couldn't fetch page resources. Please check your internet connection and try again.",
          actionTitle: "retry",
          isDestructive: false,
          onPressed: () {
            Navigator.pop(context, true);
            _fetchGiftCards();
          });
      if (rez == null || rez == false) {
        Navigator.pop(context);
      }
    } else {
      setState(() {});
      _giftCardInfo = error.data;
    }
  }

  @override
  void initState() {
    _giftCardInfo = null;
    _fetchGiftCards();
    _periodicSync =
        Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      if (kDebugMode) {
        print("background task started");
      }
      ProcessError error = await adminWorker.getSingleGiftCard(
          context: context, id: widget.giftCardModel.id);
      if (error.any) {
        showSnackBar(
            context: context,
            content: "Could not Update Giftcard Countries",
            isGood: false);
      } else {
        setState(() {});
        _giftCardInfo = error.data;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        foregroundColor: kGeneralWhite,
        leading: GestureDetector(
          child: Icon(
            FlutterRemix.arrow_left_line,
            color: kTextPrimary,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await buildGiftcardMenu(
                    context: context, giftCardModel: widget.giftCardModel);
              },
              icon: Icon(
                FlutterRemix.more_fill,
                color: kPrimaryColor,
              )),
        ],
      ),
      body: Container(
        padding: kAppHorizontalPadding,
        alignment: Alignment.center,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.giftCardModel.title.inTitleCase} Gift Card Rates",
                    style: kSubTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 10
                        : screenSize.width * 0.026,
                  ),
                  Text(
                    "Select the card country to update the rates",
                    style: kSubTextStyle,
                  ),
                  SizedBox(
                    height: screenSize.width < tabletBreakPoint
                        ? 40
                        : screenSize.width * 0.1,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
                child: _giftCardInfo == null
                    ? _PageShimmer()
                    : Column(
                        children: _giftCardInfo!.countries
                            .map((e) => GiftCountryWidget(
                                  giftCountry: e,
                                  giftCardID: _giftCardInfo!.id,
                                ))
                            .toList(),
                      )),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AppFAB(
        leading: Icon(
          FlutterRemix.add_fill,
          color: kGeneralWhite,
        ),
        title: "New Country",
        onTap: () async {
          await showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            barrierColor: const Color(0xFF000000).withOpacity(0.6),
            builder: (context) {
              return CountrySelectList(
                giftcardID: widget.giftCardModel.id,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _periodicSync.cancel();
    super.dispose();
  }
}

//Page SHIMMER
class _PageShimmer extends StatelessWidget {
  const _PageShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      enabled: true,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGeneralWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 5),
                    spreadRadius: 0,
                    blurRadius: 20,
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "United Kingdom",
                      style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "5 Card Ranges",
                      style: GoogleFonts.poppins(
                        color: kTextGray,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

buildGiftcardMenu(
    {required BuildContext context,
    required GiftCardModel giftCardModel}) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        "Giftcard Options",
        style: GoogleFonts.poppins(
          color: kTextPrimary,
        ),
      ),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await showCupertinoModalBottomSheet(
                context: context,
                expand: false,
                barrierColor: const Color(0xFF000000).withOpacity(0.6),
                builder: (context) {
                  return EditGiftcardPage(
                    giftCardModel: giftCardModel,
                  );
                },
              );
            },
            child: Text(
              "Edit Giftcard",
              style: GoogleFonts.poppins(color: kPrimaryColor),
            )),
        CupertinoActionSheetAction(
            onPressed: () async {
              bool? _proceed = await showOptionPopup(
                  context: context,
                  title: "Please confirm",
                  body:
                      "Are you sure you want to proceed with ${giftCardModel.status == 1 ? "dea" : "a"}ctivating this giftcard ?",
                  actionTitle:
                      "${giftCardModel.status == 1 ? "Dea" : "A"}ctivate Giftcard",
                  isDestructive: giftCardModel.status == 1);
              if (_proceed != null && _proceed) {
                showLoadingModal(
                    context: context, title: "Updating Giftcard Status");
                late ProcessError _error;
                if (giftCardModel.status == 1) {
                  _error = await adminWorker.deactivateGiftcard(
                      id: giftCardModel.id, context: context);
                } else {
                  _error = await adminWorker.activateGiftcard(
                      id: giftCardModel.id, context: context);
                }
                Navigator.pop(context);
                if (_error.any) {
                  showErrorResponse(context: context, error: _error);
                } else {
                  showInfoModal(
                      context: context,
                      title: "Success",
                      content: "Giftcard status updated successfully");
                }
              }
            },
            child: Text(
              "${giftCardModel.status == 1 ? "Dea" : "A"}ctivate Giftcard",
              style: GoogleFonts.poppins(
                  color: giftCardModel.status == 1 ? kYellow : kGreen),
            )),
      ],
      cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(color: kTextSecondary),
          )),
    ),
  );
}
