import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../main.dart';
import '../models/gift-card-mode.dart';
import '../services-classes/app-worker.dart';
import '../widgets/persistent-slide-control-delegate.dart';
import '../widgets/show-option-modal.dart';

class SellGiftCardPage extends StatefulWidget {
  const SellGiftCardPage({Key? key}) : super(key: key);

  @override
  _SellGiftCardPageState createState() => _SellGiftCardPageState();
}

TextEditingController _searchController = TextEditingController();

class _SellGiftCardPageState extends State<SellGiftCardPage> {
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
      if (rez == null || rez == false) {
        Navigator.pop(context);
      }
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    _fetchGiftCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Select Gift Card",
          style: GoogleFonts.poppins(color: kTextPrimary),
        ),
        backgroundColor: kGeneralWhite,
        elevation: 0,
        iconTheme: IconTheme.of(context).copyWith(color: kTextPrimary),
        foregroundColor: kGeneralWhite,
      ),
      backgroundColor: kGeneralWhite,
      body: Container(
        padding: kAppHorizontalPadding,
        alignment: Alignment.center,
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
            SliverToBoxAdapter(
              child: Provider.of<AppData>(context, listen: false)
                          .giftCardList ==
                      null
                  ? _PageShimmer()
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15),
                      itemBuilder: (context, index) {
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
                      itemCount: Provider.of<AppData>(context)
                          .giftCardList!
                          .where((element) => element.title
                              .toLowerCase()
                              .contains(
                                  _searchController.text.trim().toLowerCase()))
                          .toList()
                          .length,
                    ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 80,
              ),
            ),
          ],
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
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F6),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl:
                  "https://cdn.giftcardstonaira.com/gift-cards/3mP0xO9wKmdfxBPblBDnz4Vo2tGiMrpVeqOkOLSk.png",
              fit: BoxFit.cover,
              width: (screenSize.width - 60) / 2,
              height: ((screenSize.width - 60) / 2) * 0.6,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            giftCardModel.title,
            style: GoogleFonts.poppins(
                color: kPrimaryColor, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
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
