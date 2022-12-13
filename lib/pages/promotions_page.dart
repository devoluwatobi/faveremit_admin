import 'package:faveremit_admin/config/dimensions.dart';
import 'package:faveremit_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../config/styles.dart';
import '../widgets/app-fab.dart';
import '../widgets/mobile_promo_card.dart';
import 'new_promotion_page.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({Key? key}) : super(key: key);

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
        builder: (context, appData, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: kGeneralWhite,
              foregroundColor: kGeneralWhite,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  FlutterRemix.arrow_left_line,
                  color: kTextPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                "Promotions",
                style: GoogleFonts.poppins(
                    color: kTextPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            body: ListView(
              padding: kAppHorizontalPadding,
              children: [
                const SizedBox(height: 24),
                Column(
                  children: appData.homeDataModel!.promotions.map((promo) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              color: kGeneralWhite,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: kInactive.withOpacity(.4))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              PromotionCard(
                                promo: promo,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                promo.promotionUrl,
                                style: GoogleFonts.poppins(
                                    color: kDarkBG,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            ),
            floatingActionButton: AppFAB(
              leading: Icon(
                FlutterRemix.add_fill,
                color: kGeneralWhite,
              ),
              title: "New Promo",
              onTap: () async {
                await showCupertinoModalBottomSheet(
                  context: context,
                  expand: false,
                  barrierColor: const Color(0xFF000000).withOpacity(0.6),
                  builder: (context) {
                    return const NewPromotionPage();
                  },
                );
              },
            )));
  }
}
