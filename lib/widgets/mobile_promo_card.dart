import 'package:cached_network_image/cached_network_image.dart';
import 'package:faveremit_admin/services-classes/functions.dart';
import 'package:flutter/material.dart';

import '../../pages/webview_page.dart';
import '../models/home-data-info.dart';

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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewPage(
                    title: promo.title.inTitleCase,
                    url: promo.promotionUrl.trim()),
              ));
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
