import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/home-data-info.dart';
import '../pages/edit_promotions_page.dart';

class PromotionCard extends StatelessWidget {
  final Promotion promo;
  const PromotionCard({
    Key? key,
    required this.promo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () async {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => WebViewPage(
          //           title: promo.title.inTitleCase,
          //           url: promo.promotionUrl.trim()),
          //     ));
          await showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            barrierColor: const Color(0xFF000000).withOpacity(0.6),
            builder: (context) {
              return EditPromotionsPage(promo: promo);
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: promo.bannerUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
