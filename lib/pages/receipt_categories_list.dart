import 'package:faveremit_admin/config/dimensions.dart';
import 'package:faveremit_admin/config/styles.dart';
import 'package:faveremit_admin/extensions/show_or_not_extension.dart';
import 'package:faveremit_admin/pages/create_category_page.dart';
import 'package:faveremit_admin/widgets/giftcard_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';
import '../models/giftcard-country-model.dart';
import '../services-classes/app-worker.dart';
import '../widgets/app-fab.dart';

GiftCardCountry? _giftCardCountry;
List<ReceiptCategory> _cats = [];

late RefreshController _refreshController;

class CategoriesListPage extends StatefulWidget {
  final List<ReceiptCategory> categories;
  final GiftCardRange range;
  const CategoriesListPage(
      {Key? key, required this.categories, required this.range})
      : super(key: key);

  @override
  _CategoriesListPageState createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  void _onRefresh() async {
    ProcessError error = await adminWorker.getSingleGiftCountry(
        context: context, id: widget.range.giftCardCountryId);
    if (error.any) {
      _refreshController.refreshFailed();
    } else {
      _giftCardCountry = error.data;
      _cats = _giftCardCountry!.ranges
          .firstWhere((element) => element.id == widget.range.id)
          .receiptCategories;
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

  @override
  void initState() {
    _cats = widget.range.receiptCategories;
    _refreshController = RefreshController(initialRefresh: true);
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
            "Receipt Categories",
            style: GoogleFonts.poppins(color: kTextPrimary),
          ),
        ),
        floatingActionButton: AppFAB(
          leading: Icon(
            FlutterRemix.add_fill,
            color: kGeneralWhite,
          ),
          title: "New Category",
          onTap: () async {
            await showCupertinoModalBottomSheet(
              context: context,
              expand: false,
              barrierColor: const Color(0xFF000000).withOpacity(0.6),
              builder: (context) {
                return CreateCategoryPage(
                  range: widget.range,
                );
              },
            );
            _onRefresh();
          },
        ).showOrHide(Provider.of<UserData>(context, listen: false)
                    .userModel!
                    .user
                    .role !=
                null &&
            Provider.of<UserData>(context, listen: false)
                    .userModel!
                    .user
                    .role! ==
                1),
        body: SmartRefresher(
          header: const WaterDropHeader(),
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView(
            padding: kAppHorizontalPadding.copyWith(top: 20),
            children: List.generate(_cats.length,
                (index) => SingleGiftCardCategory(category: _cats[index])),
          ),
        ),
      ),
    );
  }
}
