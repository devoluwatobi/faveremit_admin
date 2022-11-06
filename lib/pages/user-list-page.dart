import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/models/dx-user-model.dart';
import 'package:faveremit_admin/pages/user-details.page.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../services-classes/app-worker.dart';
import '../widgets/persistent-slide-control-delegate.dart';
import '../widgets/show-option-modal.dart';
import 'home-page.dart';

ProcessError? _trxResponse;
late Timer _periodicSyncTimer;
TextEditingController _searchController = TextEditingController();

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

int _usersTab = 0;

class _UserListPageState extends State<UserListPage> {
  _refreshUsers() async {
    _trxResponse = await adminWorker.getUserList(
      context: context,
    );
    setState(() {});
    if (_trxResponse!.any) {
      bool? temp = await showSingleOptionPopup(
          context: context,
          title: "Oops!",
          body:
              "Unable update users list please check your internet and try again",
          actionTitle: "Retry",
          onPressed: () {
            Navigator.pop(context, true);
            _refreshUsers();
          },
          isDestructive: false);
      if (temp == null &&
          Provider.of<AppData>(context, listen: false).users == null) {
        Navigator.pop(
          context,
        );
      }
    }
  }

  @override
  void initState() {
    _refreshUsers();
    _usersTab = 0;
    _searchController.clear();
    if (Provider.of<AppData>(context, listen: false).users == null) {
      _refreshUsers();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Faveremit Users",
          style: GoogleFonts.poppins(
              color: kTextPrimary, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconTheme.of(context).copyWith(
          color: kTextPrimary,
        ),
        leading: IconButton(
          icon: Icon(
            FlutterRemix.arrow_left_line,
            color: kTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: kGeneralWhite,
        foregroundColor: kGeneralWhite,
        elevation: 0,
      ),
      backgroundColor: kGeneralWhite,
      body: Container(
        padding: kAppHorizontalPadding,
        child: Provider.of<AppData>(context).users == null
            ? Shimmer.fromColors(
                baseColor: kTextGray.withOpacity(0.3),
                highlightColor: kTextGray.withOpacity(0.1),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // const SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 20,
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                        child: CupertinoSlidingSegmentedControl(
                      onValueChanged: (newValue) {},
                      groupValue: 0,
                      children: {
                        0: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Users",
                            style: GoogleFonts.poppins(
                              color: kTextGray,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        1: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Admins",
                            style: GoogleFonts.poppins(
                              color: kTextGray,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        )
                      },
                    )),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 10, bottom: 60),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx(),
                        DummyTrx()
                      ])),
                    )
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // const SliverToBoxAdapter(
                  //   child: SizedBox(
                  //     height: 20,
                  //   ),
                  // ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: AppPersistentSlideControlDelegate(
                      widget: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.width < tabletBreakPoint
                                ? 10
                                : screenSize.width * 0.02),
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl(
                          onValueChanged: (newValue) {
                            setState(() {
                              _usersTab = int.parse(newValue.toString());
                            });
                          },
                          groupValue: _usersTab,
                          children: {
                            0: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Users",
                                style: GoogleFonts.poppins(
                                  color: _usersTab == 0
                                      ? kPrimaryColor
                                      : kTextGray,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            1: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Admins",
                                style: GoogleFonts.poppins(
                                  color: _usersTab == 1
                                      ? kPrimaryColor
                                      : kTextGray,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        CupertinoSearchTextField(
                          onChanged: (x) {
                            setState(() {});
                          },
                          controller: _searchController,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return DXUserWidget(
                            user: _usersTab == 0
                                ? Provider.of<AppData>(context)
                                    .users!
                                    .where((element) => element.role == 0)
                                    .toList()
                                    .where((element) =>
                                        element.name.toLowerCase().contains(_searchController.text.trim().toLowerCase()) ||
                                        element.email.toLowerCase().contains(
                                            _searchController.text
                                                .trim()
                                                .toLowerCase()))
                                    .toList()[index]
                                : Provider.of<AppData>(context)
                                    .users!
                                    .where((element) => element.role != 0)
                                    .toList()
                                    .where((element) =>
                                        element.name.toLowerCase().contains(
                                            _searchController.text
                                                .trim()
                                                .toLowerCase()) ||
                                        element.email
                                            .toLowerCase()
                                            .contains(_searchController.text.trim().toLowerCase()))
                                    .toList()[index]);
                      },
                      childCount: _usersTab == 0
                          ? Provider.of<AppData>(context)
                              .users!
                              .where((element) => element.role == 0)
                              .toList()
                              .where((element) =>
                                  element.name.toLowerCase().contains(_searchController.text
                                      .trim()
                                      .toLowerCase()) ||
                                  element.email.toLowerCase().contains(
                                      _searchController.text
                                          .trim()
                                          .toLowerCase()))
                              .toList()
                              .length
                          : Provider.of<AppData>(context)
                              .users!
                              .where((element) => element.role != 0)
                              .toList()
                              .where((element) =>
                                  element.name.toLowerCase().contains(
                                      _searchController.text
                                          .trim()
                                          .toLowerCase()) ||
                                  element.email
                                      .toLowerCase()
                                      .contains(_searchController.text.trim().toLowerCase()))
                              .toList()
                              .length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _periodicSyncTimer.cancel();
    super.dispose();
  }
}

class DXUserWidget extends StatelessWidget {
  final FavUserModel user;
  const DXUserWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          barrierColor: user.status == 1
              ? const Color(0xFF000000).withOpacity(0.6)
              : kYellow,
          builder: (context) {
            return UserDetailsPage(user: user);
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.only(left: 10, right: 16),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(
                color: Color(0xFFE8EBF3), width: 1, style: BorderStyle.solid),
            boxShadow: [],
            borderRadius: BorderRadius.circular(10),
            color: kGeneralWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: user.photo.toString(),
                // imageUrl: pallyWorker.baseUrl + user.photo.toString(),
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorWidget: (context, x, y) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    alignment: Alignment.center,
                    child: Text(
                      getInitials(user.name).toUpperCase(),
                      style: GoogleFonts.poppins(
                          color: kGeneralWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name.inTitleCase,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kTextGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
