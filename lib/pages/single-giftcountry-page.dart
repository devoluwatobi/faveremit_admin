import 'dart:async';

import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/pages/create-range-page.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:faveremit_admin/widgets/show-snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/giftcard-country-model.dart';
import '../models/single-giftcard-model.dart';
import '../services-classes/app-worker.dart';
import '../services-classes/info-modal.dart';
import '../widgets/app-fab.dart';
import '../widgets/giftcard-range-widget.dart';
import '../widgets/loading-modal.dart';
import '../widgets/show-option-modal.dart';

GiftCardCountry? _giftCardCountry;

bool _loading = false;
late Timer _periodicSync;
late RefreshController _refreshController;

class SingleCountryPage extends StatefulWidget {
  final GiftCountry giftCountry;
  final int giftcardID;
  const SingleCountryPage(
      {Key? key, required this.giftCountry, required this.giftcardID})
      : super(key: key);

  @override
  _SingleCountryPageState createState() => _SingleCountryPageState();
}

TextEditingController _searchController = TextEditingController();

class _SingleCountryPageState extends State<SingleCountryPage> {
  _fetchGiftCards() async {
    ProcessError error = await adminWorker.getSingleGiftCountry(
        context: context, id: widget.giftCountry.id);
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
      _giftCardCountry = error.data;
    }
  }

  void _onRefresh() async {
    ProcessError error = await adminWorker.getSingleGiftCountry(
        context: context, id: widget.giftCountry.id);
    if (error.any) {
      _refreshController.refreshFailed();
    } else {
      _giftCardCountry = error.data;
      _refreshController.refreshCompleted();
      setState(() {});
    }
    setState(() {});
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  _showLoading() {
    showLoadingModal(context: context);
  }

  _closeModal() {
    Navigator.pop(context);
  }

  _showError(ProcessError e) {
    showErrorResponse(context: context, error: e);
  }

  _showSuccess(String message) {
    showInfoModal(context: context, title: "Success", content: message);
  }

  _deleteRange(int id) async {
    late ProcessError _error;
    _showLoading();
    _error = await adminWorker.deleteRange(id: id, context: context);
    _closeModal();
    if (_error.any) {
      // Navigator.pop(context);
      _showError(_error);
    } else {
      // Navigator.pop(context);
      _showSuccess("Giftcard Range Deleted Successfully");
    }
    adminWorker.getSingleGiftCountry(
        context: context, id: widget.giftCountry.id);
  }

  @override
  void initState() {
    _loading = false;
    _refreshController = RefreshController(initialRefresh: false);
    _giftCardCountry = null;
    _fetchGiftCards();
    _periodicSync =
        Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      if (kDebugMode) {
        print("background task started");
      }
      ProcessError error = await adminWorker.getSingleGiftCountry(
          context: context, id: widget.giftCountry.id);
      if (error.any) {
        showSnackBar(
            context: context,
            content: "Could not Update Giftcard Ranges",
            isGood: false);
      } else {
        setState(() {});
        _giftCardCountry = error.data;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
      appBar: AppBar(
        title: const Text(""),
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
                bool? _proceed = await showOptionPopup(
                    context: context,
                    title: "Please confirm",
                    body:
                        "Are you sure you want to update the status of this giftcard country ?",
                    actionTitle: "I'm Sure",
                    isDestructive: true);
                if (_proceed != null && _proceed) {
                  showLoadingModal(context: context, title: "Updating Status");
                  late ProcessError _error;
                  var giftCountry;
                  if (widget.giftCountry.status == 1) {
                    _error = await adminWorker.deactivateCountry(
                        id: widget.giftCountry.id, context: context);
                  } else {
                    _error = await adminWorker.activateCountry(
                        id: widget.giftCountry.id, context: context);
                  }
                  Navigator.pop(context);
                  if (_error.any) {
                    // Navigator.pop(context);
                    showErrorResponse(context: context, error: _error);
                  } else {
                    // Navigator.pop(context);
                    showInfoModal(
                        context: context,
                        title: "Success",
                        content:
                            "Gift card country status updated successfully");
                  }
                }
              },
              icon: Icon(
                widget.giftCountry.status == 1
                    ? FlutterRemix.forbid_fill
                    : FlutterRemix.checkbox_circle_fill,
                color: widget.giftCountry.status == 1 ? kYellow : kGreen,
              )).showOrHide(Provider.of<UserData>(context, listen: false)
                      .userModel!
                      .user
                      .role !=
                  null &&
              (Provider.of<UserData>(context, listen: false)
                      .userModel!
                      .user
                      .role! ==
                  1))
        ],
      ),
      floatingActionButton: AppFAB(
        leading: Icon(
          FlutterRemix.add_fill,
          color: kGeneralWhite,
        ),
        title: "New Range",
        onTap: _giftCardCountry == null
            ? () {}
            : () async {
                await showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  barrierColor: const Color(0xFF000000).withOpacity(0.6),
                  builder: (context) {
                    return CreateRangeRatePage(
                      iso: _giftCardCountry!.iso,
                      cardCountry: widget.giftCountry.name,
                      cardTitle: _giftCardCountry!.cardTitle,
                      gift_cards_id: widget.giftcardID,
                      gift_cards_country_id: _giftCardCountry!.id,
                    );
                  },
                );
                _onRefresh();
              },
      ),
      body: Container(
        padding: kAppHorizontalPadding,
        alignment: Alignment.center,
        child: SmartRefresher(
          header: const WaterDropHeader(),
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
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
                      "${_giftCardCountry == null ? "" : _giftCardCountry!.cardTitle.inTitleCase} ${widget.giftCountry.name.toLowerCase().inTitleCase} Gift Card Rates",
                      style: kSubTitleStyle,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: screenSize.width < tabletBreakPoint
                          ? 10
                          : screenSize.width * 0.026,
                    ),
                    Text(
                      "Select the card range to update the rates",
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
                  child: _giftCardCountry == null
                      ? _PageShimmer()
                      : Column(
                          children: [
                            Column(
                              children: _giftCardCountry!.ranges
                                  .map((e) => Slidable(
                                        key: ValueKey(e.id),

                                        // The start action pane is the one at the left or the top side.
                                        startActionPane: Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .userModel!
                                                        .user
                                                        .role !=
                                                    null &&
                                                Provider.of<UserData>(context,
                                                            listen: false)
                                                        .userModel!
                                                        .user
                                                        .role! ==
                                                    1
                                            ? ActionPane(
                                                // A motion is a widget used to control how the pane animates.
                                                motion: const ScrollMotion(),

                                                dragDismissible: false,

                                                // A pane can dismiss the Slidable.
                                                dismissible: DismissiblePane(
                                                    onDismissed: () {}),

                                                // All actions are defined in the children parameter.
                                                children: [
                                                  // A SlidableAction can have an icon and/or a label.
                                                  SlidableAction(
                                                    onPressed: (context) async {
                                                      {
                                                        _showLoading();
                                                        late ProcessError
                                                            _error;
                                                        if (e.status
                                                                .toString() ==
                                                            1.toString()) {
                                                          _error = await adminWorker
                                                              .deactivateRange(
                                                                  id: e.id,
                                                                  context:
                                                                      context);
                                                        } else {
                                                          _error = await adminWorker
                                                              .activateRange(
                                                                  id: e.id,
                                                                  context:
                                                                      context);
                                                        }
                                                        setState(() {
                                                          _loading = false;
                                                        });
                                                        _closeModal();
                                                        if (_error.any) {
                                                          // Navigator.pop(context);
                                                          _showError(_error);
                                                        } else {
                                                          // Navigator.pop(context);
                                                          _showSuccess(
                                                              "Gift card range status updated successfully");
                                                        }
                                                      }
                                                    },
                                                    backgroundColor:
                                                        e.status.toString() ==
                                                                1.toString()
                                                            ? kYellow
                                                            : kGreen,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: e.status.toString() ==
                                                            1.toString()
                                                        ? FlutterRemix
                                                            .forbid_fill
                                                        : FlutterRemix
                                                            .checkbox_circle_fill,
                                                    label:
                                                        '${e.status.toString() == 1.toString() ? "Dea" : "A"}ctivate',
                                                  ),
                                                ],
                                              )
                                            : null,

                                        endActionPane: Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .userModel!
                                                        .user
                                                        .role !=
                                                    null &&
                                                Provider.of<UserData>(context,
                                                            listen: false)
                                                        .userModel!
                                                        .user
                                                        .role! ==
                                                    1
                                            ? ActionPane(
                                                // A motion is a widget used to control how the pane animates.
                                                motion: const ScrollMotion(),

                                                dragDismissible: false,

                                                // A pane can dismiss the Slidable.
                                                dismissible: DismissiblePane(
                                                    onDismissed: () {}),

                                                // All actions are defined in the children parameter.
                                                children: [
                                                  // A SlidableAction can have an icon and/or a label.
                                                  SlidableAction(
                                                    onPressed: (context) async {
                                                      {
                                                        bool? _go = await showOptionPopup(
                                                            context: context,
                                                            title:
                                                                "Please Confirm",
                                                            body:
                                                                "Are you sure you want to delete this range ?",
                                                            actionTitle:
                                                                "Yes, Delete",
                                                            isDestructive:
                                                                true);
                                                        if (_go != null &&
                                                            _go) {
                                                          _deleteRange(e.id);
                                                        }
                                                      }
                                                    },
                                                    backgroundColor: kRed,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: FlutterRemix
                                                        .delete_bin_5_fill,
                                                    label: "Delete",
                                                  ).showOrHide(Provider.of<
                                                                      UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userModel!
                                                              .user
                                                              .role !=
                                                          null &&
                                                      (Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .userModel!
                                                              .user
                                                              .role! ==
                                                          1)),
                                                ],
                                              )
                                            : null,

                                        child: SingleGiftCardRange(
                                          range: e,
                                          iso: widget.giftCountry.iso,
                                          cardCountry: widget.giftCountry.name,
                                          cardTitle:
                                              _giftCardCountry!.cardTitle,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        )),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 80,
                ),
              ),
            ],
          ),
        ),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    FlutterRemix.exchange_fill,
                    color: kPrimaryColor,
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
                        "10 - 50 AUD",
                        style: GoogleFonts.poppins(
                            color: kTextPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "updated 2 min ago",
                        style:
                            GoogleFonts.poppins(color: kTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "₦500.00",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
