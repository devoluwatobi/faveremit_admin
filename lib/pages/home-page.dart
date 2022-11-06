import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:faveremit_admin/main.dart';
import 'package:faveremit_admin/pages/app-body.dart';
import 'package:faveremit_admin/pages/update-btc-rate-page.dart';
import 'package:faveremit_admin/services-classes/app-worker.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/dimensions.dart';
import '../config/styles.dart';
import '../models/home-data-info.dart';
import '../widgets/mobile_promo_card.dart';
import '../widgets/primary-button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
        builder: (context, appData, child) => Container(
              alignment: Alignment.center,
              padding: kAppHorizontalPadding,
              child: Provider.of<AppData>(context).homeDataAvailable
                  ? CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.width < tabletBreakPoint
                                    ? 20
                                    : screenSize.width * 0.04),
                            child: Text(
                              "Hello ${getFirstName(fullName: Provider.of<UserData>(context).userModel!.user.name)}",
                              style: kSubTitleTextStyle,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Crypto Rates",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: kDarkBG,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return HomeRateCard(
                                        rate: Provider.of<AppData>(context)
                                            .homeDataModel!
                                            .cryptoRates[index]);
                                  },
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: Provider.of<AppData>(context)
                                      .homeDataModel!
                                      .cryptoRates
                                      .length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Promotions",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: kTextSecondary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                    height: 120.0,
                                    autoPlay: true,
                                    viewportFraction: .9),
                                items: appData.homeDataModel!.promotions
                                    .map((promo) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return PromotionCard(
                                        promo: promo,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Top GiftCards",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: kTextSecondary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      clientBodyPageController.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Row(children: [
                                      Text(
                                        "view all",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: kPrimaryColor),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(FlutterRemix.arrow_right_circle_fill,
                                          color: kPrimaryColor),
                                    ]),
                                  )
                                ],
                              ),
                              Container(
                                height: 140,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ListView.builder(
                                  itemBuilder: (context, index) => HomeGiftCard(
                                      giftcard: Provider.of<AppData>(context)
                                          .homeDataModel!
                                          .giftCards[index]),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Provider.of<AppData>(context)
                                      .homeDataModel!
                                      .giftCards
                                      .length,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 40,
                          ),
                        )
                      ],
                    )
                  //Shimmer
                  : SizedBox(
                      width: double.infinity,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.3),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        enabled: true,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        screenSize.width < tabletBreakPoint
                                            ? 20
                                            : screenSize.width * 0.04),
                                child: Text(
                                  "Hello ${getFirstName(fullName: Provider.of<UserData>(context).userModel!.user.name)}",
                                  style: kSubTitleTextStyle,
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                padding: EdgeInsets.all(
                                    screenSize.width < tabletBreakPoint
                                        ? 20
                                        : screenSize.width * 0.04),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.width < tabletBreakPoint
                                          ? 20
                                          : screenSize.width * 0.04),
                                  color: kFormBG,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenSize.width < tabletBreakPoint
                                                ? 10
                                                : screenSize.width * 0.02),
                                        color: Color(0xFF0C2253),
                                      ),
                                      padding: EdgeInsets.all(
                                          screenSize.width < tabletBreakPoint
                                              ? 20
                                              : screenSize.width * 0.04),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Wallet Balance",
                                            style: kWhiteSubTitleTextStyle,
                                          ),
                                          SizedBox(
                                            height: screenSize.width <
                                                    tabletBreakPoint
                                                ? 10
                                                : screenSize.width * 0.02,
                                          ),
                                          Text(
                                            "₦540,000.00",
                                            style: kWalletBalTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          screenSize.width < tabletBreakPoint
                                              ? 20
                                              : screenSize.width * 0.04,
                                    ),
                                    PrimaryButton(
                                      title: Text(
                                        "Withdraw",
                                        style: kPrimaryButtonTextStyle,
                                      ),
                                      onPressed: () async {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        screenSize.width < tabletBreakPoint
                                            ? 10
                                            : screenSize.width * 0.02),
                                child: Column(
                                  children: [
                                    // PrimaryOptionCard(
                                    //   service: PrimaryServiceObject(
                                    //       description:
                                    //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                    //       title: 'Dummy Service',
                                    //       serviceType: 0,
                                    //       id: 0),
                                    // ),
                                    // PrimaryOptionCard(
                                    //   service: PrimaryServiceObject(
                                    //       description:
                                    //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                    //       title: 'Dummy Service',
                                    //       serviceType: 0,
                                    //       id: 0),
                                    // ),
                                    // PrimaryOptionCard(
                                    //   service: PrimaryServiceObject(
                                    //       description:
                                    //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                                    //       title: 'Dummy Service',
                                    //       serviceType: 0,
                                    //       id: 0),
                                    // ),0
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Text(
                                "Recent Transactions",
                                style: kSubTitleTextStyle,
                              ),
                            ),
                            SliverList(
                                delegate: SliverChildListDelegate([
                              DummyTrx(),
                              DummyTrx(),
                              DummyTrx(),
                              DummyTrx(),
                              DummyTrx(),
                              DummyTrx(),
                            ])),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ));
  }
}

class DummyTrx extends StatelessWidget {
  const DummyTrx({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              screenSize.width < tabletBreakPoint
                  ? 20
                  : screenSize.width * 0.04),
          color: kGeneralWhite,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF606470).withOpacity(.1),
              offset: const Offset(0, 5),
              spreadRadius: 0,
              blurRadius: 20,
            )
          ]),
      width: double.infinity,
      padding: EdgeInsets.all(
          screenSize.width < tabletBreakPoint ? 10 : screenSize.width * 0.02),
      margin: EdgeInsets.symmetric(
          vertical: screenSize.width < tabletBreakPoint
              ? 10
              : screenSize.width * 0.02),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              screenSize.width < tabletBreakPoint
                  ? 10
                  : screenSize.width * 0.02,
            ),
            height: screenSize.width < tabletBreakPoint
                ? 60
                : screenSize.width * 0.12,
            width: screenSize.width < tabletBreakPoint
                ? 60
                : screenSize.width * 0.12,
            child: Image.asset(
              "assets/3d/coin.png",
              height: 40,
              width: 40,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF6E9D8),
              borderRadius: BorderRadius.circular(
                  screenSize.width < tabletBreakPoint
                      ? 10
                      : screenSize.width * 0.02),
            ),
          ),
          SizedBox(
            width: screenSize.width < tabletBreakPoint
                ? 10
                : screenSize.width * 0.02,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "500 USD",
                  style: trxTitleTextStyle,
                ),
                SizedBox(
                  height: screenSize.width < tabletBreakPoint
                      ? 5
                      : screenSize.width * 0.01,
                ),
                Text(
                  "03:42 PM Today",
                  style: trxDateTextStyle,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₦32,000.00",
                style: trxAmountTextStyle,
              ),
              SizedBox(
                height: screenSize.width < tabletBreakPoint
                    ? 5
                    : screenSize.width * 0.01,
              ),
              Text(
                "Failed",
                style: GoogleFonts.poppins(
                    color: kRed,
                    fontSize: screenSize.width < tabletBreakPoint ? 14 : 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeGiftCard extends StatelessWidget {
  final GiftCard giftcard;
  const HomeGiftCard({
    Key? key,
    required this.giftcard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: giftcard.image,
          fit: BoxFit.cover,
          width: 200,
          height: 130,
        ),
      ),
    );
  }
}

// class PrimaryServiceObject {
//   description:
//   'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//   title: 'Dummy Service',
//   serviceType: 0,
//   id: 0
// }

LinearGradient getRateGradient(int id) {
  switch (id) {
    case 1:
      return const LinearGradient(
        colors: [Color(0xFF113984), Color(0xFF009EE3)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    case 2:
      return const LinearGradient(
        colors: [Color(0xFF00A084), Color(0xFF00DEB6)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    case 3:
      return const LinearGradient(
        colors: [Color(0xFFEE7541), Color(0xFFDE5B3E)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    case 4:
      return const LinearGradient(
        colors: [Color(0xFF321DBB), Color(0xFF4183E8)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    default:
      return const LinearGradient(
        colors: [Color(0xFF113984), Color(0xFF009EE3)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
  }
}

class HomeRateCard extends StatelessWidget {
  final CryptoRate rate;
  const HomeRateCard({Key? key, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BitcoinRatePage(rate: rate)));
        }
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            gradient: getRateGradient(rate.id),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rate.crypto.name,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: kGeneralWhite,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          rate.crypto.shortCode,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kGeneralWhite,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: AppWorker().baseUrl + rate.crypto.icon.toString(),
                    height: 56,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₦${rate.value}/\$",
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: kGeneralWhite,
                        fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    FlutterRemix.arrow_right_fill,
                    color: kGeneralWhite,
                  )
                ],
              ),
            ]),
      ),
    );
  }
}
