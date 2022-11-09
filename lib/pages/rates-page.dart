import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/pages/single-giftcard-page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/gift-card-mode.dart';
import '../services-classes/app-worker.dart';
import '../widgets/persistent-slide-control-delegate.dart';
import '../widgets/show-option-modal.dart';

late RefreshController _refreshController;

class RatesPage extends StatefulWidget {
  const RatesPage({Key? key}) : super(key: key);

  @override
  _RatesPageState createState() => _RatesPageState();
}

TextEditingController _searchController = TextEditingController();

class _RatesPageState extends State<RatesPage> {
  _fetchGiftCards() async {
    ProcessError error = await adminWorker.getGiftCards(context: context);
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
      // if (rez == null || rez == false) {
      //   Navigator.pop(context);
      // }
    } else {
      setState(() {});
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    ProcessError _response = await adminWorker.getGiftCards(context: context);
    setState(() {});
    if (_response.any) {
      _refreshController.refreshFailed();
    } else {
      setState(() {});
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    if (Provider.of<AppData>(context, listen: false).giftCardList == null) {
      _fetchGiftCards();
    }
    _refreshController = RefreshController(initialRefresh: true);
    _fetchGiftCards();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGeneralWhite,
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
              // SliverPersistentHeader(delegate: delegate)
              SliverPersistentHeader(
                pinned: true,
                delegate: AppPersistentSlideControlDelegate(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoSearchTextField(
                        controller: _searchController,
                        onChanged: (x) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SliverGrid(
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2,
              //       childAspectRatio: 1.65,
              //       mainAxisSpacing: 15,
              //       crossAxisSpacing: 15),
              //   delegate: SliverChildListDelegate([
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: kInactive,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ]),
              // ),
              Provider.of<AppData>(context, listen: false).giftCardList == null
                  ? SliverToBoxAdapter(
                      child: _PageShimmer(),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GiftCardWidget(
                              giftCardModel: Provider.of<AppData>(context)
                                  .giftCardList!
                                  .where((element) => element.title
                                      .toLowerCase()
                                      .contains(_searchController.text
                                          .trim()
                                          .toLowerCase()))
                                  .toList()[index]);
                        },
                        childCount: Provider.of<AppData>(context)
                            .giftCardList!
                            .where((element) => element.title
                                .toLowerCase()
                                .contains(_searchController.text
                                    .trim()
                                    .toLowerCase()))
                            .toList()
                            .length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.05,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15)),
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
}

class GiftCardWidget extends StatelessWidget {
  final GiftCardModel giftCardModel;
  const GiftCardWidget({
    Key? key,
    required this.giftCardModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SingleGiftCardPage(
                      giftCardModel: giftCardModel,
                    )));
      },
      onLongPress: () async {
        await buildGiftcardMenu(context: context, giftCardModel: giftCardModel);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFF4F5F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: kRed,
              width: .5,
              style: giftCardModel.status == 1
                  ? BorderStyle.none
                  : BorderStyle.solid,
            )),
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 7),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                // imageUrl:
                //     "https://cdn.giftcardstonaira.com/gift-cards/3mP0xO9wKmdfxBPblBDnz4Vo2tGiMrpVeqOkOLSk.png",
                imageUrl: giftCardModel.image.toString(),
                fit: BoxFit.cover,
                width: (screenSize.width - 60) / 2,
                height: ((screenSize.width - 60) / 2) * 0.525,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              giftCardModel.title,
              style: GoogleFonts.poppins(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
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
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.65,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15),
        children: [
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kInactive,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
